# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tightvnc/tightvnc-1.2.7.ebuild,v 1.6 2003/09/05 22:01:49 msterret Exp $

IUSE="java tcpd"

S="${WORKDIR}/vnc_unixsrc"
DESCRIPTION="A great client/server software package allowing remote network access to graphical desktops."
SRC_URI="mirror://sourceforge/vnc-tight/${P}_unixsrc.tar.bz2"
HOMEPAGE="http://www.tightvnc.com/"

KEYWORDS="x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=x11-base/xfree-4.2.1
	~media-libs/jpeg-6b
	sys-libs/zlib
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )"

RDEPEND="${DEPEND}
	dev-lang/perl
	java? ( || ( >=virtual/jdk-1.3.1 >=virtual/jre-1.3.1 ) )"

src_unpack() {
	unpack ${A} && cd ${S}
	patch -p0 < ${FILESDIR}/tightvnc-${PVR}-gentoo.diff || die "Failed to patch"
}

src_compile() {
	xmkmf -a || die "xmkmf failed"

	make CDEBUGFLAGS="$CFLAGS" World || die "make World failed"
	cd Xvnc && ./configure || die "Configure failed."

	if use tcpd; then
		make EXTRA_LIBRARIES="-lwrap -lnss_nis" CDEBUGFLAGS="$CFLAGS" EXTRA_DEFINES="-DUSE_LIBWRAP=1"
	else
		make CDEBUGFLAGS="$CFLAGS"
	fi
}

src_install() {
	# the web based interface and the java viewer need the java class files
	insinto /usr/share/tightvnc/classes ; doins classes/*

	dodir /usr/share/man/man1 /usr/bin
	./vncinstall ${D}/usr/bin ${D}/usr/share/man || die "vncinstall failed"

	dodoc ChangeLog README WhatsNew
	use java && dodoc ${FILESDIR}/README.JavaViewer
	newdoc vncviewer/README README.vncviewer
}
