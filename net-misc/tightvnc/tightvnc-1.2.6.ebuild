# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tightvnc/tightvnc-1.2.6.ebuild,v 1.4 2003/02/13 15:08:33 vapier Exp $

S="${WORKDIR}/vnc_unixsrc"
DESCRIPTION="A great client/server software package allowing remote network access to graphical desktops."
SRC_URI="mirror://sourceforge/vnc-tight/${P}_unixsrc.tar.bz2"
HOMEPAGE="http://www.tightvnc.com/"

KEYWORDS="x86 ppc alpha"
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/x11
	sys-devel/perl
	~media-libs/jpeg-6b
	sys-libs/zlib"

src_unpack() {
	unpack ${A} ; cd ${S}
	#patch <${FILESDIR}/tightvnc-gentoo.diff || die

	# fix #6814
	cp vncserver vncserver.orig
	sed -e 's%^if (!xauthorityFile) {%if (!\$xauthorityFile) {%' \
		vncserver.orig > vncserver
}

src_compile() {
	xmkmf || die
	make World || die
	cd Xvnc
	./configure || die
	make || die
}

src_install() {
	dodir /usr/man
	dodir /usr/man/man1
	dodir /usr/bin

	# fix the web based interface, it needs the java class files
	dodir /usr/share/tightvnc
	dodir /usr/share/tightvnc/classes
	insinto /usr/share/tightvnc/classes ; doins classes/*

	# and then patch vncserver to point to /usr/share/tightvnc/classes
	patch -p0 < ${FILESDIR}/tightvnc-gentoo.diff || die

	./vncinstall ${D}/usr/bin ${D}/usr/man || die
}
