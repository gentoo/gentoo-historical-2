# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/pythia/pythia-6.4.22.ebuild,v 1.3 2010/05/17 11:08:14 phajdan.jr Exp $

EAPI=2
inherit versionator autotools

MV=$(get_major_version)
MY_PN=${PN}${MV}
DOC_PV=0613
EX_PV=6.4.18

DESCRIPTION="Lund Monte Carlo high-energy physics event generator"
HOMEPAGE="http://projects.hepforge.org/pythia6/"

# pythia6 from root is needed for some files to interface pythia6 with root.
# To produce a split version on mirror do, replace the 6.4.19 by the current version
# svn export http://svn.hepforge.org/pythia6/tags/v_6_4_19/ pythia-6.4.19
# tar cjf pythia-6.4.19.tar.bz2
SRC_URI="mirror://gentoo/${P}.tar.bz2
	ftp://root.cern.ch/root/pythia6.tar.gz
	doc? ( http://home.thep.lu.se/~torbjorn/pythia/lutp${DOC_PV}man2.pdf )
	examples? ( mirror://gentoo/${PN}-${EX_PV}-examples.tar.bz2 )"

LICENSE="public-domain"
SLOT="6"
KEYWORDS="~amd64 hppa ~sparc x86"
IUSE="doc examples"
DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	cp ../pythia6/tpythia6_called_from_cc.F .
	cp ../pythia6/pythia6_common_address.c .
	cat > configure.ac <<-EOF
		AC_INIT(${PN},${PV})
		AM_INIT_AUTOMAKE
		AC_PROG_F77
		AC_PROG_LIBTOOL
		AC_CHECK_LIB(m,sqrt)
		AC_CONFIG_FILES(Makefile)
		AC_OUTPUT
	EOF
	echo >> Makefile.am "lib_LTLIBRARIES = libpythia6.la"
	echo >> Makefile.am "libpythia6_la_SOURCES = \ "
	# replace wildcard from makefile to ls in shell
	for f in py*.f struct*.f up*.f fh*.f; do
		echo  >> Makefile.am "  ${f} \\"
	done
	echo  >> Makefile.am "  ssmssm.f sugra.f visaje.f pdfset.f \\"
	echo  >> Makefile.am "  tpythia6_called_from_cc.F pythia6_common_address.c"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc update_notes.txt README
	insinto /usr/share/doc/${PF}/
	if use doc; then
		doins "${DISTDIR}"/lutp${DOC_PV}man2.pdf || die
	fi
	if use examples; then
		doins -r "${WORKDIR}"/examples || die
	fi
}
