# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autoconf/autoconf-2.60.ebuild,v 1.2 2006/06/27 01:25:20 vapier Exp $

inherit eutils

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="http://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2.5"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="emacs"

DEPEND=">=sys-apps/texinfo-4.3
	=sys-devel/m4-1.4*
	dev-lang/perl"
PDEPEND=">=sys-devel/autoconf-wrapper-3.2-r1"

src_compile() {
	(use emacs && type -p emacs) \
		&& export EMACS=emacs \
		|| export EMACS=no
	econf --program-suffix="-${PV}" || die
	# From configure output:
	# Parallel builds via `make -jN' do not work.
	emake -j1 || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS NEWS README TODO THANKS \
		ChangeLog ChangeLog.0 ChangeLog.1 ChangeLog.2
}

pkg_postinst() {
	einfo "Please note that the 'WANT_AUTOCONF_2_5=1' syntax is now:"
	einfo "  WANT_AUTOCONF=2.5"
}
