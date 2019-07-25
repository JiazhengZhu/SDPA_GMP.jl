using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    ExecutableProduct(prefix, "sdpa_gmp", :sdpa_gmp),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/ericphanson/SDPA_GMP_Builder/releases/download/v7.1.3-test-1"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/SDPABuilder.v7.1.3.x86_64-linux-gnu-gcc7-cxx11.tar.gz", "68fe64c8d8c2c6b3fbdcd0a27f321c891c47a6e65a72a4e4f420cd7a025b2af9"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/SDPABuilder.v7.1.3.x86_64-linux-gnu-gcc8-cxx11.tar.gz", "1f73ab530fed1f97d15f197e1ef8871d8ed169f7b0d414fc79d657f32a1b7930"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)