# Copyright 2002 Arcady Genkin <agenkin@thpoon.com>
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-tools/alsa-tools-0.9.0_rc1.ebuild,v 1.4 2002/07/11 06:30:40 drobbins Exp $

DESCRIPTION="Advanced Linux Sound Architecture tools"
HOMEPAGE="http://www.alsa-project.org"

SRC_URI="ftp://ftp.alsa-project.org/pub/tools/${P/_rc/rc}.tar.bz2"
S="${WORKDIR}/${P/_rc/rc}"

DEPEND="virtual/glibc 
        ~media-libs/alsa-lib-0.9.0_rc1
        >=x11-libs/gtk+-1.0.1"

# This is a list of the tools in the package.
ALSA_TOOLS="ac3dec as10k1 envy24control sb16_csp seq/sbiload"

src_compile() {
    # Some of the tools don't make proper use of CFLAGS, even though
    # all of them seem to use autoconf.  This needs to be fixed.
    local f
    for f in ${ALSA_TOOLS}
    do
        cd "${S}/${f}"
        ./configure --host="${CHOST}" --prefix=/usr --mandir=/usr/share/man \
            || die "./configure failed"
        emake || die "Parallel Make Failed"
    done
}

src_install() {
    local f
    for f in ${ALSA_TOOLS}
    do
        # Install the main stuff
        cd "${S}/${f}"
        make DESTDIR="${D}" install || die

        # Install the text documentation
        local doc
        for doc in README TODO ChangeLog COPYING AUTHORS
        do
            if [ -f "${doc}" ]
            then
                mv "${doc}" "${doc}.`basename ${f}`"
                dodoc "${doc}.`basename ${f}`"
            fi
        done
    done
}
