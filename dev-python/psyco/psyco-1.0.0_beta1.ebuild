# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/psyco/psyco-1.0.0_beta1.ebuild,v 1.5 2004/05/07 20:37:03 kloeri Exp $

inherit distutils

PSYCO=${P/_beta/b}

HOMEPAGE="http://psyco.sourceforge.net/"
DESCRIPTION="Psyco is a Python extension module which can massively speed up the execution of any Python code."

SRC_URI="mirror://sourceforge/psyco/${PSYCO}-src.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""

S=${WORKDIR}/${PSYCO}
