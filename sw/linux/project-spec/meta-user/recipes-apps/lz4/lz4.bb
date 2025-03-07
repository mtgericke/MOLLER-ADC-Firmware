SUMMARY = "Extremely Fast Compression algorithm"
DESCRIPTION = "LZ4 is a very fast lossless compression algorithm, providing compression speed at 400 MB/s per core, scalable with multi-cores CPU. It also features an extremely fast decoder, with speed in multiple GB/s per core, typically reaching RAM speed limits on multi-core systems."
HOMEPAGE = "https://github.com/lz4/lz4"

LICENSE = "BSD-2-Clause | GPL-2.0-only"
LIC_FILES_CHKSUM = "file://lib/LICENSE;md5=ebc2ea4814a64de7708f1571904b32cc \
                    file://programs/COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://LICENSE;md5=d57c0d21cb917fb4e0af2454aa48b956 \
                    "

PE = "1"

SRC_URI = "git://github.com/lz4/lz4.git;branch=release;protocol=https;rev=d44371841a2f1728a3f36839fd4b7e872d0927d3 \
           file://CVE-2021-3520.patch \
           "
UPSTREAM_CHECK_GITTAGREGEX = "v(?P<pver>.*)"

S = "${WORKDIR}/git"

# Fixed in r118, which is larger than the current version.
CVE_CHECK_IGNORE += "CVE-2014-4715"

EXTRA_OEMAKE = "PREFIX=${prefix} CC='${CC}' CFLAGS='${CFLAGS}' DESTDIR=${D} LIBDIR=${libdir} INCLUDEDIR=${includedir} BUILD_STATIC=yes"

do_install() {
	oe_runmake install
}

BBCLASSEXTEND = "native nativesdk"
