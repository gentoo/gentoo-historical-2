# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xscreensaver/xscreensaver-5.14.ebuild,v 1.8 2011/10/04 21:55:20 josejx Exp $

EAPI=4
inherit autotools eutils flag-o-matic multilib pam

DESCRIPTION="A modular screen saver and locker for the X Window System"
SRC_URI="http://www.jwz.org/xscreensaver/${P}.tar.gz"
HOMEPAGE="http://www.jwz.org/xscreensaver"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="jpeg new-login opengl pam suid xinerama"

RDEPEND="x11-libs/libXmu
	x11-libs/libXxf86vm
	x11-libs/libXrandr
	x11-libs/libXxf86misc
	x11-libs/libXt
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-apps/xwininfo
	x11-apps/appres
	media-libs/netpbm
	>=dev-libs/libxml2-2.5
	>=x11-libs/gtk+-2:2
	>=gnome-base/libglade-1.99
	pam? ( virtual/pam )
	jpeg? ( virtual/jpeg )
	opengl? ( virtual/opengl )
	xinerama? ( x11-libs/libXinerama )
	new-login? ( || ( gnome-base/gdm kde-base/kdm ) )"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto
	x11-proto/xextproto
	x11-proto/scrnsaverproto
	x11-proto/recordproto
	x11-proto/xf86miscproto
	sys-devel/bc
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	xinerama? ( x11-proto/xineramaproto )"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${PN}-5.05-interix.patch

	eautoconf
}

src_configure() {
	if use ppc || use ppc64; then
		filter-flags -mabi=altivec
		filter-flags -maltivec
		append-flags -U__VEC__
	fi

	unset LINGUAS #113681
	unset BC_ENV_ARGS #24568
	export RPM_PACKAGE_VERSION="no" #368025

	econf \
		--x-includes="${EPREFIX}"/usr/include \
		--x-libraries="${EPREFIX}"/usr/$(get_libdir) \
		--enable-locking \
		--with-hackdir="${EPREFIX}"/usr/$(get_libdir)/misc/${PN} \
		--with-configdir="${EPREFIX}"/usr/share/${PN}/config \
		--with-x-app-defaults="${EPREFIX}"/usr/share/X11/app-defaults \
		--with-dpms-ext \
		$(use_with xinerama xinerama-ext) \
		--with-xinput-ext \
		--with-xf86vmode-ext \
		--with-xf86gamma-ext \
		--with-randr-ext \
		--with-proc-interrupts \
		$(use_with pam) \
		--without-kerberos \
		$(use_with new-login login-manager) \
		--with-gtk \
		$(use_with opengl gl) \
		--without-gle \
		--with-pixbuf \
		$(use_with jpeg) \
		--with-xshm-ext \
		--with-xdbe-ext \
		--with-text-file="${EPREFIX}"/etc/gentoo-release \
		$(use_with suid setuid-hacks)
}

src_install() {
	emake install_prefix="${D}" install
	dodoc README{,.hacking}

	use pam && fperms 755 /usr/bin/${PN}
	pamd_mimic_system ${PN} auth

	rm -f "${ED}"/usr/share/${PN}/config/{electricsheep,fireflies}.xml
}
