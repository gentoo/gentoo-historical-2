# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kopete/kopete-3.5.9-r1.ebuild,v 1.1 2009/05/15 02:29:11 jmbsvicetto Exp $

KMNAME=kdenetwork
EAPI="1"
inherit kde-meta eutils

SRC_URI="${SRC_URI}
	mirror://gentoo/kdenetwork-3.5-patchset-01.tar.bz2"

DESCRIPTION="KDE multi-protocol IM client"
HOMEPAGE="http://kopete.kde.org/"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="jingle ssl xscreensaver slp kernel_linux kdehiddenvisibility"
PLUGINS="addbookmarks alias autoreplace connectionstatus contactnotes crypt highlight history latex netmeeting nowlistening
	statistics texteffect translator webpresence"
PROTOCOLS="groupwise irc sametime sms winpopup yahoo"
IUSE="${IUSE} ${PLUGINS} ${PROTOCOLS}"

# Even more broken tests...
RESTRICT="test"

# The kernel_linux? ( ) conditional dependencies are for webcams, not supported
# on other kernels AFAIK
BOTH_DEPEND="
	=app-crypt/qca-1.0*
	>=dev-libs/glib-2
	dev-libs/libxml2
	dev-libs/libxslt
	net-dns/libidn
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	jingle? (
		dev-libs/expat
		>=media-libs/speex-1.1.6
		~net-libs/ortp-0.7.1
	)
	kernel_linux? ( virtual/opengl )
	sametime? ( =net-libs/meanwhile-1.0* )
	sms? ( app-mobilephone/gsmlib )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
RDEPEND="
	${BOTH_DEPEND}
	crypt? ( app-crypt/gnupg )
	latex? (
		media-gfx/imagemagick
		virtual/latex-base
	)
	ssl? ( =app-crypt/qca-tls-1.0* )
"
#	!kde-base/kdenetwork is handled by the eclass.
#	gnomemeeting is deprecated and ekiga is not yet ~ppc64
#	only needed for calling
#	netmeeting? ( net-im/gnomemeeting )"

DEPEND="
	${BOTH_DEPEND}
	x11-proto/videoproto
	kernel_linux? (
		virtual/os-headers
		x11-libs/libXv
	)
	xscreensaver? ( x11-proto/scrnsaverproto )
"

pkg_setup() {
	if use kernel_linux && ! built_with_use x11-libs/qt:3 opengl; then
		eerror "To support Video4Linux webcams in this package is required to have"
		eerror "x11-libs/qt:3 compiled with OpenGL support."
		eerror "Please reemerge x11-libs/qt:3 with USE=\"opengl\"."
		die "Please reemerge x11-libs/qt:3 with USE=\"opengl\"."
	fi
}

kopete_disable() {
	einfo "Disabling $2 $1"
	sed -i -e "s/$2//" "${S}/kopete/$1s/Makefile.am"
}

src_unpack() {
	kde-meta_src_unpack

	epatch "${FILESDIR}/${PN}-0.12_alpha1-xscreensaver.patch"
	epatch "${FILESDIR}/${PN}-3.5.5-icqfix.patch"
	epatch "${FILESDIR}/kdenetwork-3.5.5-linux-headers-2.6.18.patch"
	epatch "${FILESDIR}/${P}-icq-protocol-change.patch"
	epatch "${FILESDIR}/${PN}-3.5.10-gcc43.patch"

	use addbookmarks || kopete_disable plugin addbookmarks
	use alias || kopete_disable plugin alias
	use autoreplace || kopete_disable plugin autoreplace
	use connectionstatus || kopete_disable plugin connectionstatus
	use contactnotes || kopete_disable plugin contactnotes
	use crypt || kopete_disable plugin cryptography
	use highlight || kopete_disable plugin highlight
	use history || kopete_disable plugin history
	use latex || kopete_disable plugin latex
	use netmeeting || kopete_disable plugin netmeeting
	use nowlistening || kopete_disable plugin nowlistening
	use statistics || kopete_disable plugin statistics
	use texteffect || kopete_disable plugin texteffect
	use translator || kopete_disable plugin translator
	use webpresence || kopete_disable plugin webpresence

	kopete_disable protocol '\$(GADU)'
	use groupwise || kopete_disable protocol groupwise
	use irc || kopete_disable protocol irc
	use sametime || kopete_disable protocol meanwhile
	use winpopup || kopete_disable protocol winpopup
	use yahoo || kopete_disable protocol yahoo

	rm -f "${S}/configure"
}

src_compile() {
	local myconf="
		--without-xmms
		$(use_enable debug testbed)
		$(use_enable jingle)
		$(use_enable sametime meanwhile)
		$(use_enable sms smsgsm)
		$(use_with xscreensaver)
	"

	kde_src_compile
}

src_install() {
	kde_src_install

	rm -f "${D}${KDEDIR}"/bin/{stun,relay}server
}

pkg_postinst() {
	kde_pkg_postinst

	elog "If you would like to use Off-The-Record encryption, emerge net-im/kopete-otr."
}
