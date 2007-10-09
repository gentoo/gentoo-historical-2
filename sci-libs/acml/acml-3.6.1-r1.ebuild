# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/acml/acml-3.6.1-r1.ebuild,v 1.2 2007/10/09 22:06:21 bicatali Exp $

inherit eutils toolchain-funcs fortran

DESCRIPTION="AMD Core Math Library (ACML) for x86 and amd64 CPUs"
HOMEPAGE="http://developer.amd.com/acml.jsp"

MY_PV=${PV//\./\-}
S=${WORKDIR}
SRC_URI="x86? ( acml-${MY_PV}-gfortran-32bit.tgz )
	   amd64? ( acml-${MY_PV}-gfortran-64bit.tgz
	   int64? ( acml-${MY_PV}-gfortran-64bit-int64.tgz ) )"

RESTRICT="strip fetch"
IUSE="openmp int64 doc examples"
LICENSE="ACML"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND="app-admin/eselect-blas
	app-admin/eselect-lapack
	dev-util/pkgconfig
	openmp? ( >=sys-devel/gcc-4.2 )
	!openmp? ( =sys-devel/gcc-4.1* )"

RDEPEND="${DEPEND}
	doc? ( app-doc/blas-docs app-doc/lapack-docs )"

pkg_nofetch() {
	einfo "Please download the ACML from:"
	einfo "${HOMEPAGE}"
	einfo "and place it in ${DISTDIR}"
	einfo "The previous versions could be found at"
	einfo "http://developer.amd.com/acmlarchive.jsp"
}

pkg_setup() {
	elog "From version 3.5.0 on, ACML no longer supports"
	elog "hardware without SSE/SSE2 instructions. "
	elog "For older 32-bit without SSE/SSE2, use other blas/lapack libraries,"
	elog "or file a bug if you wish to have earlier ACML versions supported."
	FORTRAN="gfortran"
	fortran_pkg_setup
	if [[ ${FORTRANC} == gfortran ]]; then
		local gcc_version=$(gcc-major-version)$(gcc-minor-version)
		if ! use openmp && (( ${gcc_version} != 41 )); then
			eerror "You need gcc-4.1.x to test acml."
			eerror "Please use gcc-config to swicth gcc version 4.1.x"
			die "setup gcc failed"
		elif use openmp && (( ${gcc_version} != 42 )); then
			eerror "You need gfortran >= 4.2 to use openmp features."
			eerror "Please use gcc-config to switch gcc version >= 4.2"
			die "setup gcc failed"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	(DISTDIR="${S}" unpack contents-acml-*.tgz)
	case ${FORTRANC} in
		gfortran) FORT=gfortran ;;
		ifc|ifort) FORT=ifort ;;
		*) eerror "Unsupported fortran compiler: ${FORTRANC}"
			die ;;
	esac
	use openmp || rm -rf ${FORT}*_mp*
	FORTDIRS="$(ls -d ${FORT}*)"
}

src_compile() {
	einfo "Nothing to compile"
}

src_test() {
	local forts=${FORTDIRS}
	# only testing with current compiler
	use openmp && forts="$(ls -d ${FORT}*_mp*)"
	for fort in ${forts}; do
		einfo "Testing acml for ${fort}"
		cd "${S}"/${fort}/examples
		for d in . acml_mv; do
			cd "${S}"/${fort}/examples/${d}
			emake \
				ACMLDIR="${S}"/${fort} \
				F77=${FORTRANC} \
				CC="$(tc-getCC)" \
				CPLUSPLUS="$(tc-getCXX)" \
				|| die "emake test in ${fort}/examples/${d} failed"
			emake clean
		done
	done
}

src_install() {
	# respect acml default install dir (and FHS)
	local instdir=/opt/${PN}${PV}
	dodir ${instdir}

	for fort in ${FORTDIRS}; do
		# install acml
		use examples || rm -rf "${S}"/${fort}/examples
		cp -pPR "${S}/${fort}" "${D}"${instdir} || die "copy ${fort} failed"

		# install profiles
		ESELECT_PROF=acml-${FORTRANC}
		local acmldir=${instdir}/${fort}
		local libname=${acmldir}/lib/libacml
		local extlibs
		local extflags
		if [[ ${fort} =~ int64 ]]; then
			ESELECT_PROF=${ESELECT_PROF}-int64
			extflags="${extflags} -fdefault-integer-8"
		fi
		if [[ ${fort} =~ _mp ]]; then
			ESELECT_PROF=${ESELECT_PROF}-openmp
			extlibs=-lpthread
			libname=${libname}_mp
			extflags="${extflags} -fopenmp"
		fi
		for l in blas lapack; do
			# pkgconfig files
			sed -e "s:@LIBDIR@:$(get_libdir):" \
				-e "s:@PV@:${PV}:" \
				-e "s:@ACMLDIR@:${acmldir}:g" \
				-e "s:@EXTLIBS@:${extlibs}:g" \
				-e "s:@EXTFLAGS@:${extflags}:g" \
				"${FILESDIR}"/${l}.pc.in > ${l}.pc \
				|| die "sed ${l}.pc failed"
			insinto ${acmldir}/lib
			doins ${l}.pc

			# eselect files
			cat > eselect.${l} << EOF
${libname}.so /usr/@LIBDIR@/lib${l}.so.0
${libname}.so /usr/@LIBDIR@/lib${l}.so
${libname}.a /usr/@LIBDIR@/lib${l}.a
${acmldir}/lib/${l}.pc  /usr/@LIBDIR@/pkgconfig/${l}.pc
EOF
			eselect ${l} add $(get_libdir) eselect.${l} ${ESELECT_PROF}
		done
		echo "LDPATH=${acmldir}/lib" > "${S}"/35acml
		echo "INCLUDE=${acmldir}/include" >> "${S}"/35acml
	done

	doenvd "${S}"/35acml || die "doenvd failed"
	use doc || rm -rf "${S}"/Doc/acml.pdf "${S}"/Doc/html
	cp -pPR "${S}"/Doc "${D}"${instdir} || die "copy doc failed"
}

pkg_postinst() {
	for p in blas lapack; do
		local current_lib=$(eselect ${p} show | cut -d' ' -f2)
		if [[ ${current_lib} == ${ESELECT_PROF} || -z ${current_lib} ]]; then
		# work around eselect bug #189942
			local configfile="${ROOT}"/etc/env.d/${p}/lib/config
			[[ -e ${configfile} ]] && rm -f ${configfile}
			eselect ${p} set ${ESELECT_PROF}
			elog "${p} has been eselected to ${ESELECT_PROF}"
		else
			elog "Current eselected ${p} is ${current_lib}"
			elog "To use ${p} ${ESELECT_PROF} implementation, you have to issue (as root):"
			elog "\t eselect ${p} set ${ESELECT_PROF}"
		fi
	done
	if use openmp; then
		elog "Remember that if you want to use openmp"
		elog "You need to switch to gcc >= 4.2 with gcc-config"
		elog "When using ACML without openmp, stick with gcc-4.1.x"
	fi
}
