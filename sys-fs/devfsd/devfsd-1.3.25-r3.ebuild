# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/devfsd/devfsd-1.3.25-r3.ebuild,v 1.2 2003/10/09 19:51:36 pappy Exp $

IUSE=""

inherit eutils

S="${WORKDIR}/${PN}"
DESCRIPTION="Daemon for the Linux Device Filesystem"
SRC_URI="ftp://ftp.atnf.csiro.au/pub/people/rgooch/linux/daemons/devfsd/devfsd-v${PV}.tar.gz"
HOMEPAGE="http://www.atnf.csiro.au/~rgooch/linux/"

KEYWORDS="x86 amd64 ppc sparc alpha ~mips hppa arm"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}

    # http://www.gentoo.org/proj/en/hardened/etdyn-ssp.xml or #gentoo-hardened/irc.freenode
    if [ "${ARCH}" != "hppa" ] && [ "${ARCH}" != "hppa64" ] && has_version "sys-devel/hardened-gcc"
    then
        append-flags "-yet_exec -fstack-protector"
    fi

    if [ "${ARCH}" == "hppa" ] && has_version 'sys-devel/hardened-gcc'
    then
        append-flags "-yet_exec"
    fi

    if [ "${ARCH}" == "hppa64" ] && has_version 'sys-devel/hardened-gcc'
    then
        append-flags "-yet_exec"
    fi
	
	cd ${S}
	cp GNUmakefile GNUmakefile.orig
	sed -e "s:-O2:${CFLAGS}:g" \
		-e 's:/usr/man:/usr/share/man:' \
		-e '29,31d;11,16d' -e '6c\' \
		-e 'DEFINES	:= -DLIBNSL="\\"/lib/libnsl.so.1\\""' \
		GNUmakefile.orig > GNUmakefile
}

src_compile() {
	make || die
}

src_install() {
	dodir /sbin /usr/share/man /etc
	make PREFIX=${D} install || die

	#config file is handled in baselayout
	rm -f ${D}/etc/devfsd.conf

	dodoc devfsd.conf COPYING* INSTALL
}
