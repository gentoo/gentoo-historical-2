# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/boost/boost-1.34_pre20060930.ebuild,v 1.4 2006/10/29 20:17:09 dev-zero Exp $

inherit distutils multilib python versionator

MY_P=${PN}_$(replace_all_version_separators _)

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="http://www.boost.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"
LICENSE="freedist Boost-1.0"
SLOT="0"
KEYWORDS="~x86"
IUSE="bcp bjam debug doc icu pyste static threads threadsonly"

DEPEND="icu? ( >=dev-libs/icu-3.2 )"
RDEPEND="${DEPEND}
		pyste? ( dev-cpp/gccxml dev-python/elementtree )"

S=${WORKDIR}/${MY_P}

# NOTE: Before unmasking this release, there are some unresolved issues:
# - pre-stripped files
# - Check whether the threading-patch for alpha is still needed
# - Check the LICENSE, upstream updated a lot and changed licenses
# - possibility to add a separate boost-build package and depend on it
# - gccxml which is needed by pyste is broken with gcc-4.1.1, bug #147976
#   Testing gccxml-snapshot with this version of boost/pyste
# - Remove boost-jam and remove the blocker
# - Find a better way to do set the options than in pkg_setup (check whether they are really needed for installation)
# - Eventually split-out boost.python and spirit (second one has it's own release-cycle)
# - Do a 'slotmove'

pkg_setup() {
	BOOSTJAM="${S}/tools/jam/src/bin.*/bjam"

	# FIXME: Until we have a better way to do that
	NUMJOBS=$(sed -e 's/.*\(\-j[ 0-9]\+\) .*/\1/' <<< ${MAKEOPTS})

	python_version

	if [ "${ARCH}" == "amd64" ]; then
		arch=
	else
		arch=${ARCH}
	fi

	if [ "${ARCH}" == "ppc-macos" ] ; then
		BOOST_TOOLSET="darwin"
		TOOLSET_NAME="darwin"
		SOSUFFIX="dylib"
	else
		BOOST_TOOLSET="gcc"
		TOOLSET_NAME="gcc"
		SOSUFFIX="so"
	fi

	if use static ; then
		BUILD="release <runtime-link>static"
	else
		BUILD="release <runtime-link>dynamic"
	fi

	if use debug ; then
		BUILD="${BUILD} debug"
	fi

	if use threads && use threadsonly ; then
		BUILD="${BUILD} <threading>multi"
	fi

	if use threads && ! use threadsonly ; then
		BUILD="${BUILD} <threading>single/multi"
	fi

	if ! use threads ; then
		BUILD="${BUILD} <threading>single"
	fi

	if use icu ; then
		ADDITIONAL_OPTIONS="-sHAVE_ICU=1 -sICU_PATH=/usr"
	fi

}

src_compile() {
	cd "${S}/tools/jam/src"
	./build.sh ${BOOST_TOOLSET} || die "Failed to build bjam"

	cd "${S}"
	#Fixing boost with threads on alpha. Thanks to ibm <imirkin@mit.edu>
	#if use threads && [ "${ARCH}" == "alpha" ]; then
	#	epatch ${FILESDIR}/boost-alpha-threads.patch
	#fi

	${BOOSTJAM} ${NUMJOBS} -sBOOST_ROOT="${S}" \
		-sPYTHON_ROOT=/usr \
		-sPYTHON_VERSION=${PYVER} \
		-sTOOLS=${BOOST_TOOLSET} \
		-sBUILD="${BUILD}" \
		${ADDITIONAL_OPTIONS} \
		--prefix=${D}/usr \
		--layout=system

	${BOOSTJAM} ${NUMJOBS} -sBOOST_ROOT="${S}" \
		-sPYTHON_ROOT=/usr \
		-sPYTHON_VERSION=${PYVER} \
		-sTOOLS=${BOOST_TOOLSET} \
		-sBUILD="${BUILD}" \
		${ADDITIONAL_OPTIONS} \
		--prefix=${D}/usr \
		--layout=system

	if use pyste; then
		cd "${S}/libs/python/pyste/install"
		distutils_src_compile
	fi

	if use bcp; then
		cd "${S}/tools/bcp/"
		${BOOSTJAM} || die "Building bcp failed"
	fi
}

src_install () {

	cd "${S}/tools/build"
	dodir /usr/share/boost-build
	insinto /usr/share/boost-build
	cp -pPR index.html v1/ v2/ "${D}/usr/share/boost-build" || die "failed to install docs"

	cd "${S}"
	${BOOSTJAM}	${NUMJOBS} -sBOOST_ROOT="${S}" \
		-sPYTHON_ROOT=/usr \
		-sPYTHON_VERSION=${PYVER} \
		-sTOOLS=${BOOST_TOOLSET} \
		-sBUILD="${BUILD}" \
		${ADDITIONAL_OPTIONS} \
		--prefix="${D}/usr" \
		--layout=system \
		install || die "Install failed"

	dodoc README

	if use doc ; then
		dohtml 	index.htm google_logo_40wht.gif c++boost.gif boost.css \
			-A pdf -r more-r people -r doc

		find libs -type f -not -regex '^libs/[^/]*/build/.*' \
			-and -not -regex '^libs/.*/test[^/]?/.*' \
			-and -not -regex '^libs/.*/bench[^/]?/.*' \
			-and -not -regex '^libs/[^/]*/tools/.*' \
			-and -not -name \*.bat \
			-and -not -name Jamfile\* \
			-and -not -regex '^libs/[^/]*/src/.*' \
			-and -not -iname makefile \
			-and -not -name \*.mak \
			-and -not -name .\* \
			-and -not -name \*.dsw \
			-and -not -name \*.dsp \
			-exec \
				install -D -m0644 \{\} "${D}/usr/share/doc/${PF}/html/{}" \;
	fi

	#and finally set "default" links to -gcc-mt versions
	cd "${D}/usr/lib"

	for fn in $(ls -1 *.${SOSUFFIX}| cut -d- -f1 | sort -u) ; do
		if [ -f "$fn.${SOSUFFIX}" ] ; then
			dosym "$fn.${SOSUFFIX}" "/usr/lib/$fn-${TOOLSET_NAME}.${SOSUFFIX}"
		fi
		if [ -f "$fn-mt.${SOSUFFIX}" ] ; then
			dosym "$fn-mt.${SOSUFFIX}" "/usr/lib/$fn-${TOOLSET_NAME}-mt.${SOSUFFIX}"
		fi
		if [ -f "$fn-d.${SOSUFFIX}" ] ; then
			dosym "$fn-d.${SOSUFFIX}" "/usr/lib/$fn-${TOOLSET_NAME}-d.${SOSUFFIX}"
		fi
		if [ -f "$fn-mt-d.${SOSUFFIX}" ] ; then
			dosym "$fn-mt-d.${SOSUFFIX}" "/usr/lib/$fn-${TOOLSET_NAME}-mt-d.${SOSUFFIX}"
		fi
	done

	for fn in $(ls -1 *.a| cut -d- -f1 | sort -u) ; do
		if [ -f "$fn.a" ] ; then
			dosym "$fn.a" "/usr/lib/$fn-${TOOLSET_NAME}.a"
		fi
		if [ -f "$fn-mt.a" ] ; then
			dosym "$fn-mt.a" "/usr/lib/$fn-${TOOLSET_NAME}-mt.a"
		fi
		if [ -f "$fn-d.a" ] ; then
			dosym "$fn-d.a" "/usr/lib/$fn-${TOOLSET_NAME}-d.a"
		fi
		if [ -f "$fn-mt-d.a" ] ; then
			dosym "$fn-mt-d.a" "/usr/lib/$fn-${TOOLSET_NAME}-mt-d.a"
		fi
	done

	if use threads ; then
		dosym "libboost_thread-mt.a" "/usr/lib/libboost_thread.a"
		if ! use static ; then
			dosym "libboost_thread-mt.so" "/usr/lib/libboost_thread.so"
		fi
	fi

	[[ $(get_libdir) == "lib" ]] || mv "${D}/usr/lib" "${D}/usr/$(get_libdir)"

	if use pyste; then
		cd "${S}/libs/python/pyste/install"
		distutils_src_install
	fi

	if use bcp; then
		dobin "${S}/tools/bcp/run/bcp" || die "bcp install failed"
	fi

	if use bjam; then
		cd "${S}"/tools/jam/src/bin.*/
		dobin bjam || die "bjam install failed"
	fi
}

src_test() {
	cd "${S}/tools/regression"

	sed -i \
		-e "s#^\(boost_root\)=.*#\1=\"${S}\"#" \
		-e "s#^\(bjam\)=.*#\1=\"$(ls ${BOOSTJAM})\"#" \
		-e 's#tools/build/jam_src#tools/jam/src#' \
		-e 's#--comment "$comment_path" ##' \
		run_tests.sh || die "sed'ing run_tests.sh failed"
	chmod +x run_tests.sh
	./run_tests.sh || die "regression tests failed"

	elog "Please check the files in "${S}/status" for results and/or more information."
	elog "If it failed, you might want to attach the regression.log to the bug."
}
