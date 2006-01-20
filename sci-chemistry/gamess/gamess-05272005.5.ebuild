# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gamess/gamess-05272005.5.ebuild,v 1.1 2006/01/20 17:23:32 markusle Exp $

inherit eutils toolchain-funcs fortran

DESCRIPTION="A powerful quantum chemistry package"
LICENSE="gamess"
HOMEPAGE="http://www.msg.ameslab.gov/GAMESS/GAMESS.html"
SRC_URI="${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86"
IUSE="ifc hardened blas"

RESTRICT="fetch"

DEPEND="app-shells/tcsh
	ifc? ( >=dev-lang/ifc-8.1 )
	hardened? ( sys-apps/paxctl )
	blas? ( virtual/blas )"

RDEPEND="app-shells/tcsh
	net-misc/openssh
	ifc? ( >=dev-lang/ifc-8.1 )"

S="${WORKDIR}/${PN}"

GAMESS_DOWNLOAD="http://www.msg.ameslab.gov/GAMESS/License_Agreement.html"
GAMESS_VERSION="27 JUN 2005 (R5)"


pkg_nofetch() {
	echo
	einfo "Please download ${PN}-current.tar.gz from"
	einfo "${GAMESS_DOWNLOAD}."
	einfo "Be sure to select the version ${GAMESS_VERSION} tarball!!"
	einfo "Then move the tarball to"
	einfo "${DISTDIR}/${P}.tar.gz"
	echo
}

pkg_setup() {
	# make sure we have the proper fortan compiler; 
	# use ifc for USE="ifc" and g77 otherwise
	if use ifc; then
		need_fortran ifc
	else
		need_fortran g77
	fi

	# blas and ifc don't go together
	if use blas && use ifc; then
		die  "${PN} can not be compiled with USE=blas and USE=ifc"
	fi
}

src_unpack() {
	unpack ${A}

	# apply LINUX-arch patches to gamess makesfiles
	epatch "${FILESDIR}"/comp-gentoo.patch
	epatch "${FILESDIR}"/compall-gentoo.patch
	epatch "${FILESDIR}"/lked-gentoo.patch
	epatch "${FILESDIR}"/ddi-use-ssh-gentoo.patch
	epatch "${FILESDIR}"/compddi-gentoo.patch
	epatch "${FILESDIR}"/rungms-gentoo.1.patch
	epatch "${FILESDIR}"/runall-gentoo.1.patch

	# for hardened-gcc let't turn off ssp, since it breakes
	# a few routines
	cd "${S}"
	if use hardened && [[ $(tc-getF77) = f77 ]]; then
		FFLAGS="${FFLAGS} -fno-stack-protector-all"
	fi

	# greate proper activate sourcefile 
	cp "./tools/actvte.code" "./tools/actvte.f" || \
		die || "Failed to create actvte.f"
	sed -e "s/^\*UNX/    /" -i "./tools/actvte.f" || \
		die || "Failed to perform UNX substitutions in actvte.f"

	# fix GAMESS' compall script to use proper CC
	sed -e "s|\$CCOMP -c \$extraflags source/zunix.c|$(tc-getCC) -c \$extraflags source/zunix.c|" \
		-i compall || die "Failed setting up compall script"

	# insert proper FFLAGS into GAMESS' comp makefile
	# in case we're using ifc let's strip all the gcc
	# specific stuff
	if use ifc; then
		sed -e "s/-malign-double -fautomatic /-cm -w \$MODULE.f/" \
			-e "s/-Wno-globals -fno-globals \$MODULE.f//" \
			-e "s/gentoo-OPT = '-O2'/OPT = '${FFLAGS} -quiet'/" \
		    -e "s/gentoo-g77/$(tc-getF77)/" \
			-i comp || die "Failed setting up comp script"
	else
		sed -e "s/gentoo-OPT = '-O2'/OPT = '${FFLAGS}'/" \
		   	-e "s/gentoo-g77/$(tc-getF77)/" \
			-i comp || die "Failed setting up comp script"
	fi

	# use proper blas 
	if ! use blas; then
		sed -e "s|/usr/lib/libblas.a|/usr/lib/dontuselibblas.a|" \
			-i lked || die "Failed to adjust blas in lked"
	fi

	# fix up GAMESS' linker script;
	if use ifc; then
		sed -e "s/gentoo-LDR='g77'/LDR='$(tc-getF77)'/" \
		   	-e "s/gentoo-LDOPTS=' '/LDOPTS='${LDFLAGS}'/" \
			-i lked || die "Failed setting up lked script"
	else
		sed -e "s/gentoo-LDR='g77'/LDR='$(tc-getF77)'/" \
			-e "s/gentoo-LDOPTS=' '/LDOPTS='${LDFLAGS}'/" \
			-i lked || die "Failed patching lked script"
	fi

	# fix up GAMESS' ddi TCP/IP socket build
	sed -e "s/gentoo-CC = 'gcc'/CC = '$(tc-getCC)'/" \
		-i ddi/compddi || die "Failed setting up compddi script"

	# for ifc we have to fix the number of underscores of fortran
	# symbols, otherwise the linker will barf
	if use ifc; then
		sed -e "s/gentoo-F77_OPTS = '-DINT_SIZE=int -D_UNDERSCORES=2/F77_OPTS = '-DINT_SIZE=int -D_UNDERSCORES=1/" \
			-i ddi/compddi || die "Failed fixing underscores in compddi"
	else
		sed -e "s/gentoo-F77_OPTS/F77_OPTS/" \
		    -i ddi/compddi || die "Failed fixing underscores in compddi"
	fi
}

src_compile() {
	# build actvte
	cd "${S}"/tools
	$(tc-getF77) -o actvte.x actvte.f || die "Failed to compile actvte.x"

	# for hardened (PAX) users and ifc we need to turn
	# MPROTECT off
	if use ifc && use hardened; then
		/sbin/paxctl -PemRxS actvte.x 2> /dev/null || \
			die "paxctl failed on actvte.x"
	fi

	# build gamess
	cd "${S}"
	./compall || die "compall failed"

	# build the ddi TCP/IP socket stuff
	cd ${S}/"ddi"
	./compddi || die "compddi failed"

	# finally, link it all together
	cd "${S}"
	./lked || die "lked failed"

	# for hardened (PAX) users and ifc we need to turn
	# MPROTECT off
	if use ifc && use hardened; then
		/sbin/paxctl -PemRxS ${PN}.00.x 2> /dev/null || \
			die "paxctl failed on actvte.x"
	fi
}

src_install() {
	cd "${S}"

	# the executables
	dobin ${PN}.00.x ddi/ddikick.x rungms \
		|| die "Failed installing binaries"

	# the docs
	dodoc *.DOC || die "Failed installing docs"

	# install ericftm
	insinto /usr/share/${PN}/ericfmt
	doins ericfmt.dat || die "Failed installing ericfmt.dat"

	# install mcpdata
	insinto /usr/share/${PN}/mcpdata
	doins mcpdata/* || die "Failed installing mcpdata"

	# install the tests the user should run, and
	# fix up the runscript; also grab a copy of rungms
	# so the user is ready to run the tests
	insinto /usr/share/${PN}/tests
	insopts -m0644
	doins tests/* || die "Failed installing tests"
	insopts -m0744
	doins runall || die "Failed installing tests"
}

pkg_postinst() {
	echo
	ewarn "Before you use GAMESS for any serious work you HAVE"
	ewarn "to run the supplied test files located in"
	ewarn "/usr/share/gamess/tests and check them thoroughly."
	ewarn "Otherwise all scientific publications resulting from"
	ewarn "your GAMESS runs should be immediately rejected :)"
	ewarn "To do so copy the content of /usr/share/gamess/tests"
	ewarn "to some temporary location and execute './runall'. "
	ewarn "Please consult TEST.DOC and the other docs!"
	ewarn "NOTE: Due to a g77 implementation issue the TDHF code"
	ewarn "      currently does not work and exam39 will, therefore,"
	ewarn "      not run properly. Please watch bug #114367 "
	ewarn "      for this issue!"

	if use ifc; then
		echo
		ewarn "IMPORTANT NOTE: We STRONGLY recommend to stay away"
		ewarn "from ifc-9.0 for now and use the ifc-8.1 series of"
		ewarn "compilers UNLESS you can run through ALL of the "
		ewarn "test cases (see above) successfully."
	fi

	echo
	einfo "If you want to run on more than a single CPU"
	einfo "you will have to acquaint yourself with the way GAMESS"
	einfo "does multiprocessor runs and adjust rungms according to"
	einfo "your target network architecture."
	echo
}
