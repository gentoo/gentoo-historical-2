# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tightvnc/tightvnc-1.3.10-r1.ebuild,v 1.7 2009/10/04 17:17:54 armin76 Exp $

inherit eutils toolchain-funcs java-pkg-opt-2

IUSE="java tcpd server"

S="${WORKDIR}/vnc_unixsrc"
DESCRIPTION="A great client/server software package allowing remote network access to graphical desktops."
SRC_URI="mirror://sourceforge/vnc-tight/${P}_unixsrc.tar.bz2
		java? ( mirror://sourceforge/vnc-tight/${P}_javasrc.tar.gz )"
HOMEPAGE="http://www.tightvnc.com/"

KEYWORDS="alpha amd64 arm hppa ~mips ppc sh sparc x86 ~x86-fbsd"
LICENSE="GPL-2"
SLOT="0"

CDEPEND="media-fonts/font-misc-misc
	media-libs/jpeg
	server? (
		media-fonts/font-cursor-misc
		x11-apps/rgb
		x11-apps/xauth
		x11-apps/xsetroot
	)
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXp
	x11-libs/libXt
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.4 )"
DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.4 )
	x11-proto/xextproto
	x11-proto/xproto
	server? (
		x11-proto/inputproto
		x11-proto/kbproto
		x11-proto/printproto
	)
	>=x11-misc/imake-1
	x11-misc/gccmakedep
	x11-misc/makedepend
	!net-misc/vnc"

src_unpack() {

	if ! use server;
	then
		echo
		einfo "The 'server' USE flag will build tightvnc's server."
		einfo "If '-server' is chosen only the client is built to save space."
		einfo "Stop the build now if you need to add 'server' to USE flags.\n"
		ebeep
		epause 5
	fi

	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-1.3.10-pathfixes.patch" # fixes bug 78385 and 146099
	epatch "${FILESDIR}/${PN}-1.3.8-imake-tmpdir.patch" # fixes bug 23483
	epatch "${FILESDIR}/${PN}-1.3.8-darwin.patch" # fixes bug 89908
	epatch "${FILESDIR}/${PN}-1.3.8-mips.patch"
	epatch "${FILESDIR}"/server-CVE-2007-1003.patch
	epatch "${FILESDIR}"/server-CVE-2007-1351-1352.patch
	epatch "${FILESDIR}"/1.3.9-fbsd.patch
	epatch "${FILESDIR}"/1.3.9-arm.patch
	epatch "${FILESDIR}"/1.3.9-sh.patch

	if use java; then
		cd "${WORKDIR}"
		epatch "${FILESDIR}/${PN}-1.3.10-java-build.patch"
	fi
}

src_compile() {
	xmkmf -a || die "xmkmf failed"

	make CDEBUGFLAGS="${CFLAGS}" World || die

	if use server; then
		cd Xvnc && ./configure || die "Configure failed."
		if use tcpd; then
			local myextra="-lwrap"
			make EXTRA_LIBRARIES="${myextra}" \
				CDEBUGFLAGS="${CFLAGS}"  \
				EXTRA_DEFINES="-DUSE_LIBWRAP=1" || die
		else
			make CDEBUGFLAGS="${CFLAGS}" || die
		fi
	fi
	if use java; then
		cd "${WORKDIR}/vnc_javasrc" || die
		make JAVACFLAGS="$(java-pkg_javac-args)" all || die
	fi

}

src_install() {
	# the web based interface and the java viewer need the java class files
	if use java; then
		java-pkg_newjar "${WORKDIR}/vnc_javasrc/VncViewer.jar"
		java-pkg_dolauncher "${PN}-java"
		insinto /usr/share/${PN}/classes
		doins "${WORKDIR}"/vnc_javasrc/*.vnc || die
		dosym /usr/share/${PN}/lib/${PN}.jar /usr/share/${PN}/classes/VncViewer.jar

	fi

	dodir /usr/share/man/man1 /usr/bin
	./vncinstall "${D}"/usr/bin "${D}"/usr/share/man || die "vncinstall failed"

	if use server; then
		newconfd "${FILESDIR}"/tightvnc.confd vnc
		newinitd "${FILESDIR}"/tightvnc.initd vnc
	else
		rm -f "${D}"/usr/bin/vncserver
		rm -f "${D}"/usr/share/man/man1/{Xvnc,vncserver}*
	fi

	doicon "${FILESDIR}"/vncviewer.png
	make_desktop_entry vncviewer vncviewer vncviewer Network

	dodoc ChangeLog README WhatsNew
	use java && dodoc "${FILESDIR}"/README.JavaViewer
	newdoc vncviewer/README README.vncviewer
}
