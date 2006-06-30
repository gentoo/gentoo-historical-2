# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gaim/gaim-2.0.0_beta3-r1.ebuild,v 1.3 2006/06/30 15:51:09 gothgirl Exp $

inherit flag-o-matic eutils toolchain-funcs debug multilib mono autotools perl-module

MY_PV=${PV/_beta/beta}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="http://gaim.sourceforge.net/"
SRC_URI="mirror://sourceforge/gaim/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="audiofile bonjour cjk dbus debug eds gadu gnutls krb4 mono nas nls perl silc spell startup-notification tcltk xscreensaver custom-flags"

RDEPEND="
	audiofile? ( media-libs/libao
		media-libs/audiofile )
	bonjour? ( net-misc/howl )
	dbus? ( >=sys-apps/dbus-0.35
		>=dev-lang/python-2.4 )
	>=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	nas? ( >=media-libs/nas-1.4.1-r1 )
	perl? ( >=dev-lang/perl-5.8.2-r1 )
	spell? ( >=app-text/gtkspell-2.0.2 )
	gadu?  ( net-libs/libgadu )
	gnutls? ( net-libs/gnutls )
	!gnutls? ( >=dev-libs/nss-3.11
		>=dev-libs/nspr-4.6.1 )
	silc? ( >=net-im/silc-toolkit-0.9.12-r3 )
	eds? ( gnome-extra/evolution-data-server )
	krb4? ( >=app-crypt/mit-krb5-1.3.6-r1 )
	tcltk? ( dev-lang/tcl
		dev-lang/tk )
	startup-notification? ( >=x11-libs/startup-notification-0.5 )
	mono? ( dev-lang/mono )
	xscreensaver? ( x11-misc/xscreensaver )"

DEPEND="$RDEPEND
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"


S="${WORKDIR}/${MY_P}"

# List of plugins
#   app-accessibility/festival-gaim
#   net-im/gaim-blogger
#   net-im/gaim-bnet
#   net-im/gaim-meanwhile
#   net-im/gaim-snpp
#   x11-plugins/autoprofile
#   x11-plugins/gaim-assistant
#   x11-plugins/gaim-encryption
#   x11-plugins/gaim-extprefs
#   x11-plugins/gaim-latex
#   x11-plugins/gaim-otr
#   x11-plugins/gaim-rhythmbox
#   x11-plugins/gaim-xmms-remote
#   x11-plugins/gaimosd
#   x11-plugins/guifications


print_gaim_warning() {
	ewarn
	ewarn "This is a beta release!  Please back up everything in your .gaim"
	ewarn "directory. We're looking for lots of feedback on this release"
	ewarn "especially what you love about it and what you hate about it."
	ewarn
	ewarn "Again, this is a beta release and should not be used by those"
	ewarn "with a heart condition, if you are pregnant, or if you are under"
	ewarn "the age of 8. Side-effects include awesomeness, dumbfoundedness,"
	ewarn "dry mouth and lava. Consult your doctor to find out if"
	ewarn "${MY_P} is right for you."
	ewarn
	ewarn "If you are merging ${MY_P} from an earlier version, you may need"
	ewarn "to re-merge any plugins like gaim-encryption or gaim-snpp."
	ewarn
	ewarn "If you experience problems with gaim, file them as bugs with"
	ewarn "Gentoo's bugzilla, http://bugs.gentoo.org.  DO NOT report them"
	ewarn "as bugs with gaim's sourceforge tracker, and by all means DO NOT"
	ewarn "seek help in #gaim."
	ewarn
	ewarn "Be sure to USE=\"debug\" and include a backtrace for any seg"
	ewarn "faults, see http://gaim.sourceforge.net/gdb.php for details on"
	ewarn "backtraces."
	ewarn
	ewarn "Please read the gaim FAQ at http://gaim.sourceforge.net/faq.php"
	ewarn
	einfo
	if  use custom-flags; then
		einfo "Note that you have shown NOT TO FILTER UNSTABLE C[XX]FLAGS."
		einfo "DO NOT file bugs with GENTOO or UPSTREAM while using custom-flags"
		einfo
	else
		einfo "Note that we are now filtering all unstable flags in C[XX]FLAGS."
		einfo
	fi

	if use silc; then
		einfo "To be able to connect to silc network, you need to run"
		einfo "\`usermod -c \"comment\"\` as user as which you are running gaim,"
		einfo "where \"comment\" is either your real name if you want show it"
		einfo "on silc or any othe not empty string."
		einfo
	fi
	ebeep 5
	epause 3
}

pkg_setup() {
	print_gaim_warning
	if use krb4 && ! built_with_use app-crypt/mit-krb5 krb4 ; then
	eerror
	eerror You need to rebuild app-crypt/mit-krb5 with USE=krb4 in order to
	eerror enable krb4 support for the zephyr protocol in gaim.
	eerror
	die "Configure failed"
	fi

	if use gadu && built_with_use net-libs/libgadu ssl ; then
	eerror
	eerror You need to rebuild net-libs/libgadu with USE=-ssl in order
	eerror enable gadu gadu support in gaim.
	eerror
	die "Configure failed"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-as-needed.patch

	eautomake || die "Failed running eautomake"
}

src_compile() {
	# Stabilize things, for your own good
	if ! use custom-flags; then
		strip-flags
	fi
	replace-flags -O? -O2

	# -msse2 doesn't play nice on gcc 3.2
	[ "`gcc-version`" == "3.2" ] && filter-flags -msse2

	local myconf

	if ! use bonjour ; then
		myconf="${myconf} --with-howl-includes=."
		myconf="${myconf} --with-howl-libs=."
	fi

	if ! use silc; then
		einfo "Disabling SILC protocol"
		myconf="${myconf} --with-silc-includes=."
		myconf="${myconf} --with-silc-libs=."
	fi

	if ! use gadu ; then
		myconf="${myconf} --with-gadu-includes=."
		myconf="${myconf} --with-gadu-libs=."
	fi

	if use gnutls ; then
		einfo "Disabling NSS, using GnuTLS"
		myconf="${myconf} --enable-nss=no"
		myconf="${myconf} --with-gnutls-includes=/usr/include/gnutls"
		myconf="${myconf} --with-gnutls-libs=/usr/$(get_libdir)"
	else
		einfo "Disabling GnuTLS, using NSS"
		myconf="${myconf} --enable-gnutls=no"
	fi

	econf \
		$(use_enable nls) \
		$(use_enable perl) \
		$(use_enable spell gtkspell) \
		$(use_enable startup-notification) \
		$(use_enable tcltk tcl) \
		$(use_enable tcltk tk) \
		$(use_enable xscreensaver screensaver) \
		$(use_enable mono) \
		$(use_enable krb4) \
		$(use_enable debug) \
		$(use_enable dbus) \
		$(use_enable nas) \
		$(use_enable eds gevolution) \
		$(use_enable audiofile audio) \
		${myconf} || die "Configuration failed"

	emake -j1 || die "Make failed"
}

src_install() {
	make install DESTDIR=${D} || die "Install failed"
	use perl && fixlocalpod
	dodoc ABOUT-NLS AUTHORS COPYING HACKING INSTALL NEWS PROGRAMMING_NOTES README ChangeLog VERSION
}

pkg_postinst() {
	print_gaim_warning
}
