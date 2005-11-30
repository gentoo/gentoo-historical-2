# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Authen-PAM/Authen-PAM-0.14.ebuild,v 1.1 2003/06/05 15:17:21 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Interface to PAM library"
SRC_URI="http://www.cs.kuleuven.ac.be/~pelov/pam/download/${P}.tar.gz"
HOMEPAGE="http://www.cs.kuleuven.ac.be/~pelov/pam/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha"

DEPEND="${DEPEND}
	sys-libs/pam"


export OPTIMIZE="$CFLAGS"
