# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vnc/vnc-4.1.2.ebuild,v 1.25 2007/04/12 17:43:35 armin76 Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
inherit eutils toolchain-funcs multilib autotools

XSERVER_VERSION="1.1.1"
PATCH_VER=2

MY_P="vnc-4_1_2-unixsrc"
DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="http://www.realvnc.com/"
SRC_URI="http://ltsp.mirrors.tds.net/pub/ltsp/tarballs/${MY_P}.tar.gz
	http://ftp.plusline.de/FreeBSD/distfiles/xc/${MY_P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCH_VER}.tar.bz2
	server? ( ftp://ftp.freedesktop.org/pub/xorg/individual/xserver/xorg-server-${XSERVER_VERSION}.tar.bz2	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE="server"

RDEPEND="sys-libs/zlib
	media-libs/freetype
	x11-libs/libSM
	x11-libs/libXtst
	server? (
		x11-libs/libXi
		x11-libs/libXfont
		x11-libs/libXmu
		x11-libs/libxkbfile
		x11-libs/libXrender
		x11-apps/xauth
		x11-apps/xsetroot
		media-fonts/font-adobe-100dpi
		media-fonts/font-adobe-75dpi
		media-fonts/font-alias
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		>=x11-base/xorg-server-1.1
	)
	!net-misc/tightvnc"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	server?	(
		x11-proto/compositeproto
		x11-proto/damageproto
		x11-proto/fixesproto
		x11-proto/fontsproto
		x11-proto/randrproto
		x11-proto/resourceproto
		x11-proto/scrnsaverproto
		x11-proto/trapproto
		x11-proto/videoproto
		x11-proto/xineramaproto
		x11-proto/xf86bigfontproto
		x11-proto/xf86dgaproto
		x11-proto/xf86miscproto
		x11-proto/xf86vidmodeproto
	)"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! use server ; then
		echo
		einfo "The 'server' USE flag will build vnc's server."
		einfo "If '-server' is chosen only the client is built to save space."
		einfo "Stop the build now if you need to add 'server' to USE flags.\n"
		ebeep
		epause 5
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use server ; then
		mv "${WORKDIR}"/xorg-server-${XSERVER_VERSION} unix/
	else
		rm -f "${WORKDIR}"/patch/*vnc-server*
	fi
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	cd unix
	eautoreconf
	cd ../common
	eautoreconf

	if use server ; then
		cd "${S}"
		cp -a unix/xc/programs/Xserver/vnc/Xvnc/xvnc.cc \
			unix/xc/programs/Xserver/Xvnc.man \
			unix/xc/programs/Xserver/vnc/*.{h,cc} \
			unix/xorg-server-*/hw/vnc
		cp -a unix/xorg-server-*/{cfb/cfb.h,hw/vnc}
		cp -a unix/xorg-server-*/{fb/fb.h,hw/vnc}
		cp -a unix/xorg-server-*/{fb/fbrop.h,hw/vnc}
		sed -i -e 's,xor,c_xor,' -e 's,and,c_and,' \
			unix/xorg-server*/hw/vnc/{cfb,fb,fbrop}.h
		cd unix/xorg-server-*
		eautoreconf
	fi
}

src_compile() {
	cd unix
	econf --with-installed-zlib --with-fb || die "econf failed"
	emake || die "emake failed"

	if use server ; then
		cd xorg-server-*
		econf \
			--enable-xorg \
			--disable-dependency-tracking \
			--disable-xprint \
			--disable-static \
			--enable-composite \
			--with-xkb-output=/usr/share/X11/xkb \
			--with-rgb-path=/usr/share/X11/rgb.txt \
			--disable-xorgcfg \
			--disable-dmx \
			--disable-lbx \
			--enable-xdmcp \
			--disable-xevie \
			--disable-dri \
			--with-int10=stub \
			--with-default-font-path=/usr/share/fonts/misc,/usr/share/fonts/75dpi,/usr/share/fonts/100dpi,/usr/share/fonts/TTF,/usr/share/fonts/Type1 \
			|| die "econf server failed"
		emake CDEBUGFLAGS="${CFLAGS}" CXXDEBUGFLAGS="${CXXFLAGS}" || die "emake server failed"
	fi
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	use server && dodir /usr/$(get_libdir)/xorg/modules/extensions

	cd unix
	./vncinstall "${D}"/usr/bin "${D}"/usr/share/man "${D}"/usr/$(get_libdir)/xorg/modules/extensions || die "failed to run vncinstall"
	cd ..

	doicon ${FILESDIR}/vncviewer.png
	make_desktop_entry vncviewer vncviewer vncviewer.png Network

	dodoc README

	if use server ; then
		newconfd "${FILESDIR}"/vnc.confd vnc
		newinitd "${FILESDIR}"/vnc.initd vnc
	else
		cd "${D}"
		rm usr/bin/vncserver
		rm usr/bin/x0vncserver
		rm usr/share/man/man1/vnc{passwd,config,server}.1
		rm usr/share/man/man1/x0vncserver.1
		rm usr/bin/vncpasswd
		rm usr/bin/vncconfig
	fi
}
