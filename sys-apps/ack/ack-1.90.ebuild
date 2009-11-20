# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ack/ack-1.90.ebuild,v 1.3 2009/11/20 15:22:22 maekke Exp $

inherit perl-module bash-completion

DESCRIPTION="ack is a tool like grep, aimed at programmers with large trees of heterogeneous source code"
HOMEPAGE="http://www.petdance.com/ack/"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_TEST=do

DEPEND=">=dev-perl/File-Next-1.02
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_install() {
	perl-module_src_install
	dobashcompletion etc/ack.bash_completion.sh
}

pkg_postinst() {
	perl-module_pkg_postinst
	bash-completion_pkg_postinst
}
