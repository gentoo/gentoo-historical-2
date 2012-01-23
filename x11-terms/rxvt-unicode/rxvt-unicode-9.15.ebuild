# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt-unicode/rxvt-unicode-9.15.ebuild,v 1.3 2012/01/23 23:39:51 wired Exp $

EAPI="4"

inherit autotools

DESCRIPTION="rxvt clone with xft and unicode support"
HOMEPAGE="http://software.schmorp.de/pkg/rxvt-unicode.html"
SRC_URI="http://dist.schmorp.de/rxvt-unicode/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="
	256-color alt-font-width afterimage blink buffer-on-clear +focused-urgency
	fading-colors +font-styles iso14755 +mousewheel +perl pixbuf secondary-wheel
	startup-notification truetype unicode3 +vanilla wcwidth
"

RDEPEND="
	>=sys-libs/ncurses-5.7-r6
	afterimage? ( || ( media-libs/libafterimage x11-wm/afterstep ) )
	kernel_Darwin? ( dev-perl/Mac-Pasteboard )
	media-libs/fontconfig
	perl? ( dev-lang/perl )
	pixbuf? ( x11-libs/gdk-pixbuf x11-libs/gtk+:2 )
	startup-notification? ( x11-libs/startup-notification )
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXrender
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
	x11-proto/xproto
"

REQUIRED_USE="vanilla? ( !alt-font-width !buffer-on-clear focused-urgency !secondary-wheel !wcwidth )"

src_prepare() {
	# fix for prefix not installing properly
	epatch "${FILESDIR}"/${PN}-9.06-case-insensitive-fs.patch

	if ! use afterimage && ! use pixbuf; then
		einfo " + If you want transparency support, please enable either the *pixbuf*"
		einfo "   or the *afterimage* USE flag. Enabling both will default to pixbuf."
	fi

	if ! use vanilla; then
		ewarn " + You are going to include unsupported third-party bug fixes/features."

		use wcwidth && epatch doc/wcwidth.patch

		# bug #240165
		use focused-urgency || epatch "${FILESDIR}"/${PN}-9.06-no-urgency-if-focused.diff

		# bug #263638
		epatch "${FILESDIR}"/${PN}-9.06-popups-hangs.patch

		# bug #237271
		epatch "${FILESDIR}"/${PN}-9.05_no-MOTIF-WM-INFO.patch

		# support for wheel scrolling on secondary screens
		use secondary-wheel && epatch "${FILESDIR}"/${PN}-9.14-secondary-wheel.patch

		# ctrl-l buffer fix
		use buffer-on-clear && epatch "${FILESDIR}"/${PN}-9.14-clear.patch

		use alt-font-width && epatch "${FILESDIR}"/${PN}-9.06-font-width.patch
	fi

	# kill the rxvt-unicode terminfo file - #192083
	sed -i -e "/rxvt-unicode.terminfo/d" doc/Makefile.in || die "sed failed"

	eautoreconf
}

src_configure() {
	local myconf=''

	use iso14755 || myconf='--disable-iso14755'

	econf --enable-everything \
		$(use_enable 256-color) \
		$(use_enable afterimage) \
		$(use_enable blink text-blink) \
		$(use_enable fading-colors fading) \
		$(use_enable font-styles) \
		$(use_enable mousewheel) \
		$(use_enable perl) \
		$(use_enable pixbuf) \
		$(use_enable startup-notification) \
		$(use_enable truetype xft) \
		$(use_enable unicode3) \
		${myconf}
}

src_compile() {
	emake || die "emake failed"

	sed -i \
		-e 's/RXVT_BASENAME = "rxvt"/RXVT_BASENAME = "urxvt"/' \
		"${S}"/doc/rxvt-tabbed || die "tabs sed failed"
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc README.FAQ Changes
	cd "${S}"/doc
	dodoc README* changes.txt etc/* rxvt-tabbed
}

pkg_postinst() {
	if use buffer-on-clear; then
		ewarn "You have enabled the buffer-on-clear USE flag."
		ewarn "Please note that, although this works well for most prompts,"
		ewarn "there have been cases with fancy prompts, like bug #397829,"
		ewarn "where it caused issues. Proceed with caution."
		ewarn "  (keep this terminal open until you make sure it works)"
	fi
	if use secondary-wheel; then
		elog "You have enabled the secondary-wheel USE flag."
		elog "This allows you to scroll in secondary screens"
		elog "(like mutt's message list/view) using the mouse wheel."
		elog
		elog "To actually enable the feature you have to add"
		elog "  URxvt*secondaryWheel: true"
		elog "in your ~/.Xdefaults file"
	fi
}
