# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xscreensaver/xscreensaver-5.04-r1.ebuild,v 1.1 2008/02/14 13:08:05 drac Exp $

inherit autotools eutils fixheadtails flag-o-matic multilib pam

DESCRIPTION="A modular screen saver and locker for the X Window System"
SRC_URI="http://www.jwz.org/xscreensaver/${P}.tar.gz"
HOMEPAGE="http://www.jwz.org/xscreensaver"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="jpeg new-login opengl pam suid xinerama"

RDEPEND="x11-libs/libXxf86misc
	x11-apps/xwininfo
	x11-apps/appres
	media-libs/netpbm
	>=dev-libs/libxml2-2.5
	>=x11-libs/gtk+-2
	>=gnome-base/libglade-1.99
	pam? ( virtual/pam )
	jpeg? ( media-libs/jpeg )
	opengl? ( virtual/opengl )
	xinerama? ( x11-libs/libXinerama )
	new-login? ( gnome-base/gdm )"
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

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-nsfw.patch
	epatch "${FILESDIR}"/${P}-desktop-entry.patch
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
	ht_fix_all
}

src_compile() {
	# Simple workaround for the ppc* arches flurry screensaver, needed for <=5.04
	filter-flags -mabi=altivec
	filter-flags -maltivec
	append-flags -U__VEC__

	unset BC_ENV_ARGS

	econf \
		--with-x-app-defaults=/usr/share/X11/app-defaults \
		--with-hackdir=/usr/$(get_libdir)/misc/${PN} \
		--with-configdir=/usr/share/${PN}/config \
		--x-libraries=/usr/$(get_libdir) \
		--x-includes=/usr/include \
		--with-dpms-ext \
		--with-xf86vmode-ext \
		--with-xf86gamma-ext \
		--with-proc-interrupts \
		--with-xpm \
		--with-xshm-ext \
		--with-xdbe-ext \
		--enable-locking \
		--without-kerberos \
		--without-gle \
		--with-gtk \
		$(use_with suid setuid-hacks) \
		$(use_with new-login login-manager) \
		$(use_with xinerama xinerama-ext) \
		$(use_with pam) \
		$(use_with opengl gl) \
		$(use_with jpeg)

	# Bug 155049.
	emake -j1 || die "emake failed."
}

src_install() {
	emake install_prefix="${D}" install || die "emake install failed."

	dodoc README*

	use pam && fperms 755 /usr/bin/${PN}
	pamd_mimic_system ${PN} auth

	# Bug 135549.
	rm -f "${D}"/usr/share/${PN}/config/electricsheep.xml
	rm -f "${D}"/usr/share/${PN}/config/fireflies.xml
	dodir /usr/share/man/man6x
	mv "${D}"/usr/share/man/man6/worm.6 \
		"${D}"/usr/share/man/man6x/worm.6x
}
