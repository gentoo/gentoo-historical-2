# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/enscript/enscript-1.6.4-r3.ebuild,v 1.2 2008/03/04 03:07:51 jer Exp $

inherit eutils

DESCRIPTION="powerful text-to-postscript converter"
SRC_URI="http://www.iki.fi/mtr/genscript/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/enscript/enscript.html"

KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
LICENSE="GPL-2"
IUSE="nls ruby"

DEPEND="sys-devel/flex
	sys-devel/bison
	nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/enscript-1.6.3-security.patch
	epatch "${FILESDIR}"/enscript-1.6.3-language.patch
	epatch "${FILESDIR}"/enscript-catmur.patch
	epatch "${FILESDIR}"/enscript-1.6.4-ebuild.st.patch
	use ruby && epatch "${FILESDIR}"/enscript-1.6.2-ruby.patch
}

src_compile() {
	unset CC
	econf `use_enable nls` || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog FAQ.html NEWS README* THANKS TODO
	insinto /usr/share/enscript/hl
	doins "${FILESDIR}"/ebuild.st
	use ruby && doins "${FILESDIR}"/ruby.st
}

pkg_postinst() {
	elog "Now, customize /etc/enscript.cfg."
}
