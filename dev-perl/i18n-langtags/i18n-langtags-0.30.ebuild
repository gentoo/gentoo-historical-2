# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/i18n-langtags/i18n-langtags-0.30.ebuild,v 1.2 2004/06/25 00:38:45 agriffis Exp $

inherit perl-module

MY_P=I18N-LangTags-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="RFC3066 language tag handling for Perl"
HOMEPAGE="http://www.cpan.org/modules/by-module/I18N/${MY_P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/I18N/${MY_P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64"

SRC_TEST="do"

src_compile() {
	perl-module_src_compile
	perl-module_src_test || die "test failed"
}
