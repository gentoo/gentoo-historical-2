 #Copyright 1999-2002 Gentoo Technologies, Inc.
 # Distributed under the terms of the GNU General Public License, v2 or later
 # $Header: /var/cvsroot/gentoo-x86/dev-perl/Locale-gettext/Locale-gettext-1.01.ebuild,v 1.1 2002/10/24 14:04:58 mcummings Exp $

 inherit perl-module

 MY_P="gettext-${PV}"
 S=${WORKDIR}/${MY_P}

 DESCRIPTION="A Perl module for accessing the GNU locale utilities"
 HOMEPAGE="http://cpan.org/modules/by-module/Locale/${MY_P}.readme"
 SRC_URI="http://cpan.org/modules/by-module/Locale/${MY_P}.tar.gz"

 LICENSE="Artistic"
 SLOT="0"
 KEYWORDS="x86 sparc sparc64 ~ppc ~alpha"

 DEPEND="${DEPEND}
         sys-devel/gettext"
