# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/iwidgets/iwidgets-4.0.1-r2.ebuild,v 1.4 2010/12/07 19:56:39 jlec Exp $

EAPI="3"

inherit eutils multilib

MY_P="${PN}${PV}"
ITCL_MY_P="itcl3.2.1"

DESCRIPTION="Widget collection for incrTcl/incrTk"
HOMEPAGE="http://incrtcl.sourceforge.net/itcl/"
SRC_URI="mirror://sourceforge/incrtcl/${MY_P}.tar.gz
	mirror://sourceforge/incrtcl/${ITCL_MY_P}_src.tgz"

LICENSE="as-is BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	>=dev-tcltk/itcl-3.2.1
	>=dev-tcltk/itk-3.2.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-path.patch
	sed -i -e "/^\(LIB\|SCRIPT\)_INSTALL_DIR =/s|lib|$(get_libdir)|" \
		Makefile.in || die

	# Bug 115470
	rm doc/panedwindow.n
}

src_configure() {
	econf --with-itcl="${WORKDIR}/${ITCL_MY_P}" || die "configure failed"
	# we don't need to compile anything
}

src_compile() {
	:
}

src_install() {
	# parallel borks #177088
	emake -j1 INSTALL_ROOT="${D}" install || die "emake install failed"

	dodoc CHANGES ChangeLog README

	# bug 247184 - iwidget installs man pages in /usr/man
#	mkdir -p "${ED}"/usr/share/man/mann
#	mv "${ED}"/usr/man/mann/* "${ED}"/usr/share/man/mann/
#	rm -rf "${ED}"/usr/man

	# demos are in the wrong place:
#	mkdir -p "${ED}/usr/share/doc/${PF}"
#	mv "${ED}/usr/$(get_libdir)/${MY_P}/demos" "${ED}/usr/share/doc/${PF}/"
}
