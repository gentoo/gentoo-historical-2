# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-Reload/Apache-Reload-0.110.0.ebuild,v 1.6 2012/03/02 21:46:30 ranger Exp $

EAPI=4

MODULE_AUTHOR=PHRED
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Perl module for Apache::Reload"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="alpha amd64 hppa ~ia64 ppc ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="www-apache/mod_perl"
DEPEND="${RDEPEND}"
