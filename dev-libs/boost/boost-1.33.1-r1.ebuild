# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/boost/boost-1.33.1-r1.ebuild,v 1.15 2007/02/20 20:32:25 dev-zero Exp $

inherit eutils distutils multilib python versionator

MY_P=${PN}_$(replace_all_version_separators _)

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="http://www.boost.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="freedist Boost-1.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="bcp bjam debug doc icu pyste threads threadsonly"

# Overriding var from python.eclass
PYVER="2.4"

DEPEND="icu? ( >=dev-libs/icu-3.2 )
		sys-libs/zlib
		=dev-lang/python-2.4*"
RDEPEND="${DEPEND}
		pyste? ( dev-cpp/gccxml dev-python/elementtree )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gcc41_visit_each.patch"

	# Don't strip (safest approach atm)
	sed -i \
		-e 's/-s\b//g' \
		tools/build/jam_src/build.jam \
		tools/build/v1/gcc-tools.jam \
		|| die "sed failed"
}

pkg_setup() {
	BOOSTJAM="${S}/tools/build/jam_src/bin.*/bjam"

	# FIXME: Until we have a better way to do that
	NUMJOBS=$(sed -e 's/.*\(\-j[ 0-9]\+\) .*/\1/' <<< ${MAKEOPTS})

	python_version

	if [ "${ARCH}" == "amd64" ]; then
		arch=
	else
		arch=${ARCH}
	fi

	if use ppc-macos ; then
		BOOST_TOOLSET="darwin"
		TOOLSET_NAME="darwin"
		SOSUFFIX="dylib"
	else
		BOOST_TOOLSET="gcc"
		TOOLSET_NAME="gcc"
		SOSUFFIX="so"
	fi

	BUILD="release <runtime-link>dynamic"

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
	cd "${S}/tools/build/jam_src"
	./build.sh ${BOOST_TOOLSET} || die "Failed to build bjam"

	cd "${S}"
	# Fixing boost with threads on alpha. Thanks to ibm <imirkin@mit.edu>
	if use threads && [ "${ARCH}" == "alpha" ]; then
		epatch ${FILESDIR}/boost-alpha-threads.patch
	fi

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
		dosym "libboost_thread-mt.so" "/usr/lib/libboost_thread.so"
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
		cd "${S}"/tools/build/jam_src/bin.*/
		dobin bjam || die "bjam install failed"
	fi

	if has test ${FEATURES} ; then
		cd "${S}/status"
		elog "Tests enabled, installing the output to:"
		elog "  ${ROOT}usr/share/doc/${PF}/status"
		elog "The results are in"
		elog "  ${ROOT}usr/share/doc/${PF}/status/cs-$(uname).html"
		docinto status
		sed -i -e 's|../boost.png|boost.png|' *.html
		dohtml *.{html,gif} ../boost.png
		dodoc regress.log
	fi
}

src_test() {
	ewarn "This test might take a couple of hours even on a recent machine"
	ewarn "and you need 2 GB free space in your temp directory."
	ebeep

	elog "It is possible to provide a regression_comment file"
	elog "which might be useful it you intend to send the generated"
	elog "regression results table to the boost-developers."
	elog "Just export a variable BOOST_COMMENT_PATH before starting"
	elog "the merge containing the full path to such a file."
	elog "If you don't know what's this all about, just ignore it."

	if [ -n ${BOOST_COMMENT_PATH} ] ; then
		elog "Creating default comment file..."
		cat > comment.html <<- __EOF__
			<p>Tests are run on Gentoo Linux.</p>
		__EOF__
		BOOST_COMMENT_PATH="$(pwd)/comment.html"
	fi


	cd "${S}/tools/regression"
	sed -i \
		-e "s|\(boost_root\)=.*|\1=\"${S}\"|" \
		-e "s|\(toolset\)=.*|\1=\"${BOOST_TOOLSET}\"|" \
		-e "s|\(test_tools\)=.*|\1=\"${BOOST_TOOLSET}\"|" \
		-e "s|\(comment_path\)=.*|\1=\"${BOOST_COMMENT_PATH}\"|" \
		run_tests.sh || die "sed failed"
	. run_tests.sh || die "tests failed"

	elog "You have to check the test output yourself"
	elog "to see whether all tests succeeded."
}
