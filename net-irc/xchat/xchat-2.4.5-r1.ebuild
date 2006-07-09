# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat/xchat-2.4.5-r1.ebuild,v 1.10 2006/07/09 05:43:35 kumba Exp $

inherit flag-o-matic eutils versionator

DESCRIPTION="Graphical IRC client"
SRC_URI="http://www.xchat.org/files/source/$(get_version_component_range 1-2)/${P}.tar.bz2
	mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${PN}-dccserver-0.5.patch.bz2"
HOMEPAGE="http://www.xchat.org/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha ~amd64 ~hppa ia64 mips ppc ~ppc64 sparc ~x86"
IUSE="perl tcl python ssl mmx ipv6 nls xchattext xchatnogtk xchatdccserver"

RDEPEND=">=dev-libs/glib-2.0.3
	!xchatnogtk? ( >=x11-libs/gtk+-2.0.3 )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	perl? ( >=dev-lang/perl-5.6.1 )
	python? ( >=dev-lang/python-2.2 )
	tcl? ( dev-lang/tcl )
	!<net-irc/xchat-gnome-0.9"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7
	>=sys-apps/sed-4
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/xc245-fix-te-notify.diff
	epatch "${FILESDIR}"/44_fix_alignment_endianess.dpatch

	use xchatdccserver && epatch "${DISTDIR}"/xchat-dccserver-0.5.patch.bz2

	# use libdir/xchat/plugins as the plugin directory
	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e 's:${prefix}/lib/xchat:${libdir}/xchat:' \
			"${S}"/configure{,.in} || die
	fi
}

src_compile() {
	# Added for to fix a sparc seg fault issue by Jason Wever <weeve@gentoo.org>
	if [ ${ARCH} = "sparc" ] ; then
		replace-flags "-O[3-9]" "-O2"
	fi

	# xchat's configure script uses sys.path to find library path
	# instead of python-config (#25943)
	unset PYTHONPATH

	econf \
		$(use_enable ssl openssl) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable tcl) \
		$(use_enable mmx) \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_enable xchattext textfe) \
		$(use_enable !xchatnogtk gtkfe) \
		--program-suffix=-2 \
		|| die "Configure failed"

	emake || die "Compile failed"
}

src_install() {
	# some magic to create a menu entry for xchat 2
	sed -i \
		-e "s:^Exec=xchat$:Exec=xchat-2:" \
		-e "s:Name=XChat IRC:Name=XChat 2 IRC:" \
		xchat.desktop

	make DESTDIR="${D}" install || die "Install failed"

	# install plugin development header
	insinto /usr/include/xchat
	doins src/common/xchat-plugin.h || die "doins failed"

	dodoc ChangeLog README* || die "dodoc failed"
}
