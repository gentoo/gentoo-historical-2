# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MLDBM/MLDBM-2.00-r1.ebuild,v 1.1 2002/05/05 18:47:51 seemant Exp $

. /usr/portage/eclass/inherit.eclass || die
inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A multidimensional/tied hash Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-authors/id/GSAR/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-authors/id/GSAR/${P}.readme"
