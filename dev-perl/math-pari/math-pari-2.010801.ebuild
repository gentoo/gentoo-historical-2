# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/math-pari/math-pari-2.010801.ebuild,v 1.7 2010/05/05 18:52:30 halcy0n Exp $

inherit perl-module eutils

MY_P="Math-Pari-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl interface to PARI"
HOMEPAGE="http://www.cpan.org/authors/id/I/IL/ILYAZ/modules/${MY_P}.readme"
SRC_URI="mirror://cpan/authors/id/I/IL/ILYAZ/modules/${MY_P}.tar.gz
		http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.1.7.tgz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~mips ppc sparc x86"
IUSE=""

SRC_TEST="do"

# Math::Pari requires that a copy of the pari source in a parallel
# directory to where you build it. It does not need to compile it, but
# it does need to be the same version as is installed, hence the hard
# DEPEND below
# Math::Pari does NOT work with 2.3. The Makefile.PL gives warnings, and if you
# run the tests, you get failures.
DEPEND="~sci-mathematics/pari-2.1.7
		!=sci-mathematics/pari-2.3*
		dev-lang/perl"

src_compile() {
	# Unfortunately the assembly routines math-pari has for SPARC do not appear
	# to be working at current.  Perl cannot test math-pari or anything that
	# pulls in the math-pari module as DynaLoader cannot load the resulting
	# .so files math-pari generates.  As such, we have to use the generic
	# non-machine specific assembly methods here.
	use sparc && myconf="${myconf} machine=none"

	perl-module_src_compile
}
