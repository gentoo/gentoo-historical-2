# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-EN-Inflect/Lingua-EN-Inflect-1.89.2.ebuild,v 1.4 2010/11/05 14:07:59 ssuominen Exp $

EAPI=2

inherit versionator
MODULE_AUTHOR="DCONWAY"
MY_P="${PN}-$(delete_version_separator 2)"
S="${WORKDIR}/${MY_P}"
inherit perl-module

DESCRIPTION="Perl module for Lingua::EN::Inflect"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 ~sparc x86"
IUSE=""

SRC_TEST="do"

src_prepare() {
	perl-module_src_prepare
	rm "${S}"/Build.pl || die
	sed -i "/^Build.pl/d" "${S}"/MANIFEST || die
}
