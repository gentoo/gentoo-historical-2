# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/TermReadKey/TermReadKey-2.19.ebuild,v 1.9 2002/10/17 16:43:15 bjb Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Change terminal modes, and perform non-blocking reads."
HOMEPAGE="http://cpan.valueclick.com/authors/id/J/JS/JSTOWE/${P}.readme"
SRC_URI="http://cpan.valueclick.com/authors/id/J/JS/JSTOWE/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64 alpha"

mymake="/usr"
