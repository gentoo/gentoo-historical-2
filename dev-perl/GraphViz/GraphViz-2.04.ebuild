# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GraphViz/GraphViz-2.04.ebuild,v 1.2 2009/05/30 23:12:17 tcunha Exp $

MODULE_AUTHOR=LBROCARD
inherit perl-module

DESCRIPTION="GraphViz - Interface to the GraphViz graphing tool"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="test"
SRC_TEST="do"

RDEPEND="dev-lang/perl
	media-gfx/graphviz
	dev-perl/IPC-Run"
	#dev-perl/XML-Twig #used in GraphViz::XML
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

src_install() {
	perl-module_src_install

	insinto /usr/share/doc/${PF}/examples
	doins "${S}"/examples/* || die
}
