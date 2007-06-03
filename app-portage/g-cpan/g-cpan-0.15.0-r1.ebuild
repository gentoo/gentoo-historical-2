# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/g-cpan/g-cpan-0.15.0-r1.ebuild,v 1.2 2007/06/03 05:45:28 kumba Exp $

inherit perl-module

DESCRIPTION="g-cpan: generate and install CPAN modules using portage"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/g-cpan.xml"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="dev-lang/perl
		>=dev-perl/yaml-0.60
		dev-perl/Shell-EnvImporter
		dev-perl/Log-Agent"

src_install() {
		perl-module_src_install
		diropts "-m0755"
		dodir "/var/tmp/g-cpan"
		keepdir "/var/tmp/g-cpan"
		dodir "/var/log/g-cpan"
		keepdir "/var/log/g-cpan"
}

pkg_postinst() {
	elog "You may wish to adjust the permissions on /var/tmp/g-cpan"
	elog "if you have users besides root expecting to use g-cpan."
}
