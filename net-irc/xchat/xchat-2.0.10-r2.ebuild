# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat/xchat-2.0.10-r2.ebuild,v 1.4 2004/07/31 02:22:43 tgall Exp $

inherit flag-o-matic eutils

DESCRIPTION="Graphical IRC client"
SRC_URI="http://www.xchat.org/files/source/2.0/${P}.tar.bz2
	xchatdccserver? ( http://dfx.at/xchat/xchat-dccserver-0.4.patch )"
HOMEPAGE="http://www.xchat.org/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~x86 ~sparc ~hppa ~ppc ~alpha ~amd64 ~ia64 ~mips ppc64"
IUSE="perl tcltk python ssl mmx ipv6 nls"
# Local use flag for the text frontend (bug #26427)
IUSE="${IUSE} xchattext xchatnogtk xchatdccserver"

# Added for to fix a sparc seg fault issue by Jason Wever <weeve@gentoo.org>
if [ ${ARCH} = "sparc" ]
then
	replace-flags "-O3" "-O2"
fi

RDEPEND=">=dev-libs/glib-2.0.3
	!xchatnogtk? ( >=x11-libs/gtk+-2.0.3 )
	perl? ( >=dev-lang/perl-5.6.1 )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	python? ( dev-lang/python )
	tcltk? ( dev-lang/tcl )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7
	>=sys-apps/sed-4
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/xc2010-fixtabcomp2.diff
	epatch ${FILESDIR}/xc2010-fixfocus.diff
	use xchatdccserver && epatch ${DISTDIR}/xchat-dccserver-0.4.patch
}

src_compile() {

	# xchat's configure script uses sys.path to find library path
	# instead of python-config (#25943)
	unset PYTHONPATH

	# test for local usage of xchatnogtk
	local gtkconf
	use xchatnogtk \
		&& gtkconf="--disable-gtkfe" \
		|| gtkconf="--enable-gtkfe"

	econf \
		${gtkconf} \
		`use_enable ssl openssl` \
		`use_enable perl` \
		`use_enable python` \
		`use_enable tcltk tcl` \
		`use_enable mmx` \
		`use_enable ipv6` \
		`use_enable nls` \
		`use_enable xchattext textfe` \
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

	make DESTDIR=${D} install || die "Install failed"

	# install plugin development header
	insinto /usr/include/xchat
	doins src/common/xchat-plugin.h

	dodoc ChangeLog README*

}

pkg_postinst() {
	einfo
	einfo "With this release the tab completion behaviour has changed."
	einfo "See http://forum.xchat.org/viewtopic.php?p=653 for more info."
	einfo "Use '/set completion_amount 0' to revert back to the old behaviour."
	einfo
}
