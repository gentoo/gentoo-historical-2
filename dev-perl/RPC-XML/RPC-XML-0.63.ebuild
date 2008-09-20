# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/RPC-XML/RPC-XML-0.63.ebuild,v 1.1 2008/09/20 08:46:49 tove Exp $

MODULE_AUTHOR=RJRAY
inherit perl-module

DESCRIPTION="An implementation of XML-RPC"

SLOT="0"
LICENSE="|| ( Artistic-2 LGPL-2.1 )"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="test"

SRC_TEST="do"

RDEPEND=">=dev-perl/libwww-perl-5.801
	>=dev-perl/XML-LibXML-1.58
	>=dev-perl/XML-Parser-2.31
	dev-perl/net-server
	dev-lang/perl"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

pkg_postinst() {
	perl-module_pkg_postinst

	SETWARN=0
	has_version '=www-servers/apache-2*' && HAVE_APACHE2=1
	has_version '>=www-apache/mod_perl-2.0' && HAVE_MP2=2

	[ -n "${HAVE_APACHE2}" ] && SETWARN=1
	[ -n "${HAVE_MP2}" ] && SETWARN=1

	if [ "$SETWARN" == "1" ]; then
	ewarn "Apache2 or mod_perl2 were detected."
	ewarn ""
	ewarn "NOTE FROM THE AUTHOR OF RPC-XML"
	ewarn ""
	ewarn "At present, this package does not work with Apache2 and the soon-to-be"
	ewarn "mod_perl2. The changes to the API for location handlers are too drastic to"
	ewarn "try and support both within the same class (I tried, using the compatibility"
	ewarn "layer). Also, mp2 does not currently provide support for <Perl> sections, which"
	ewarn "are the real strength of the Apache::RPC::Server class."
	fi
}
