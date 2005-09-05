# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xscreensaver/xscreensaver-4.22-r4.ebuild,v 1.6 2005/09/05 18:55:51 corsair Exp $

inherit eutils flag-o-matic pam fixheadtails

IUSE="gnome jpeg kerberos krb4 insecure-savers new-login nls offensive opengl pam xinerama"

DESCRIPTION="A modular screen saver and locker for the X Window System"
SRC_URI="http://www.jwz.org/xscreensaver/${P}.tar.gz"
HOMEPAGE="http://www.jwz.org/xscreensaver/"

LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~mips ppc ppc64 sparc ~x86"
SLOT="0"

# NOTE: ignore app-games/fortune-mod as a dep. it is pluggable and won't
#       really matter if it isn't there. Maybe we should have a 'games'
#       USE flag...

# smithj says (2005-07-26):
# MOTIF WAS REMOVED FOR A REASON! The motif version has not been maintained for
# some time, and has problems both at build-time and run-time. This ebuild
# (4.22-r3) is going to force gtk support and disable motif support. Hopefully
# the users won't complain too much...

RDEPEND="virtual/x11
	media-libs/netpbm
	>=sys-libs/zlib-1.1.4
	>=dev-libs/libxml2-2.5
	>=x11-libs/gtk+-2
	>=gnome-base/libglade-1.99
	>=dev-libs/glib-2
	pam? ( virtual/pam )
	kerberos? ( krb4? ( >=app-crypt/mit-krb5-1.2.5 ) )
	jpeg? ( media-libs/jpeg )
	opengl? ( virtual/opengl
	          >=media-libs/gle-3.0.1 )
	!arm? ( new-login? ( gnome-base/gdm ) )"

DEPEND="${RDEPEND}
	sys-devel/bc
	dev-lang/perl
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

# simple workaround for the flurry screensaver
filter-flags -mabi=altivec
filter-flags -maltivec
append-flags -U__VEC__

pkg_setup() {
	if use kerberos && ! use krb4 ; then
		ewarn "You have enabled kerberos without krb4 support. Kerberos will be"
		ewarn "disabled unless kerberos 4 support has been compiled with your"
		ewarn "kerberos libraries. To do that, you should abort now and do:"
		ewarn
		ewarn " USE=\"krb4\" emerge mit-krb5"
		ewarn
		epause
	fi
	if use arm && use new-login; then
		ewarn "gnome-base/gdm is required for USE=\"new-login\", and is not"
		ewarn "available for the arm platform. please disable this use flag"
		die "new-login USE is not supported on arm"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# disable rpm -q checking, otherwise it breaks sandbox if rpm is installed
	# use gnome-terminal in tests rather than gnome-open (bug #94708)
	epatch ${FILESDIR}/${PN}-4.22-configure.patch

	# tweaks the default configuration (driver/XScreenSaver.ad.in)
	epatch ${FILESDIR}/${PN}-4.22-settings.patch

	# makes the blank screen REALLY blank
	epatch ${FILESDIR}/${PN}-blank-screen.patch

	# fixes wrong argument for inter-aggregate screensaver
	epatch ${FILESDIR}/${PN}-4.22-interaggregate.patch

	# disable not-safe-for-work xscreensavers
	use offensive || epatch ${FILESDIR}/${PN}-4.16-nsfw.patch

	# change old head/tail to POSIX ones
	#cd hacks
	ht_fix_all
}

src_compile() {
	local myconf
	use kerberos && use krb4 \
		&& myconf="${myconf} --with-kerberos" \
		|| myconf="${myconf} --without-kerberos"

	econf \
		--with-hackdir=/usr/lib/misc/xscreensaver \
		--with-configdir=/usr/share/xscreensaver/config \
		--x-libraries=/usr/$(get_libdir) \
		--x-includes=/usr/include \
		--with-mit-ext \
		--with-dpms-ext \
		--with-xf86vmode-ext \
		--with-xf86gamma-ext \
		--with-proc-interrupts \
		--with-xpm \
		--with-xshm-ext \
		--with-xdbe-ext \
		--enable-locking \
		--with-gtk \
		--with-xml \
		$(use_with insecure-savers setuid-hacks) \
		$(use_with new-login login-manager) \
		$(use_with xinerama xinerama-ext) \
		$(use_with pam) \
		$(use_with opengl gl) $(use_with opengl gle) \
		$(use_with jpeg) \
		$(use_enable nls) \
		${myconf} || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	[ -n "${KDEDIR}" ] && dodir ${KDEDIR}/bin

	make install_prefix="${D}" install || die "make install failed"

	dodoc README

	# install correctly in gnome, including info about configuration preferences
	if use gnome ; then
		dodir /usr/share/gnome/capplets
		insinto /usr/share/gnome/capplets
		doins driver/screensaver-properties.desktop

		dodir /usr/share/pixmaps
		insinto /usr/share/pixmaps
		newins ${S}/utils/images/logo-50.xpm
		xscreensaver.xpm

		dodir /usr/share/control-center-2.0/capplets
		insinto /usr/share/control-center-2.0/capplets
		newins ${FILESDIR}/desktop_entries/screensaver-properties.desktop
	fi

	# Remove "extra" capplet
	rm -f ${D}/usr/share/applications/gnome-screensaver-properties.desktop

	use pam && fperms 755 /usr/bin/xscreensaver
	pamd_mimic_system xscreensaver auth
}

pkg_postinst() {
	if ! use new-login; then
		einfo
		einfo "You have chosen to not use the new-login USE flag."
		einfo "This is a new USE flag which enables individuals to"
		einfo "create new logins when the screensaver is active,"
		einfo "allowing others to use their account, even though the"
		einfo "screen is locked to another account. If you want this"
		einfo "feature, please recompile with USE=\"new-login\"."
		einfo
	fi

	if use insecure-savers;then
		ewarn
		ewarn "You have chosen USE=insecure-savers. While upstream"
		ewarn "has made every effort to make sure these savers do not"
		ewarn "abuse their setuid root status, the possibilty exists that"
		ewarn "someone will exploit xscreensaver and will be able to gain"
		ewarn "root privledges. You have been warned."
		ewarn
	fi

	einfo
	einfo "The gtk USE flag has been dropped. gtk is now required for Gentoo's"
	einfo "xscreensaver. If this is a problem, bug upstream."
	einfo
}
