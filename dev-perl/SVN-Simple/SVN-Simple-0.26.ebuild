# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SVN-Simple/SVN-Simple-0.26.ebuild,v 1.4 2005/05/07 02:54:03 gustavoz Exp $

inherit perl-module

DESCRIPTION="SVN::Simple::Edit - Simple interface to SVN::Delta::Editor"
SRC_URI="mirror://cpan/authors/id/C/CL/CLKAO/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/C/CL/CLKAO/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~amd64 ~sparc"
IUSE=""

DEPEND="${DEPEND}
	>=dev-util/subversion-0.31"

pkg_setup() {
	if ! perl -MSVN::Core < /dev/null 2> /dev/null
	then
		eerror "You need subversion-0.31+ compiled with Perl bindings."
		eerror "USE=\"perl\" emerge subversion"
		die "Need Subversion compiled with Perl bindings."
	fi
}
