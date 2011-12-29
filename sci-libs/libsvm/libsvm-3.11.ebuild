# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libsvm/libsvm-3.11.ebuild,v 1.1 2011/12/29 19:52:41 bicatali Exp $

EAPI="4"
SUPPORT_PYTHON_ABIS="1"

inherit eutils java-pkg-opt-2 python flag-o-matic toolchain-funcs

DESCRIPTION="Library for Support Vector Mahcines"
HOMEPAGE="http://www.csie.ntu.edu.tw/~cjlin/libsvm/"
SRC_URI="http://www.csie.ntu.edu.tw/~cjlin/libsvm/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="java openmp python tools"

DEPEND="java? ( >=virtual/jdk-1.4 )"
RDEPEND="${DEPEND}
	tools? ( sci-visualization/gnuplot )"

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC)$ == *gcc* ]] && ! tc-has-openmp; then
			ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 "
			die "Need an OpenMP capable compiler"
		else
			append-ldflags -fopenmp
			append-cxxflags -fopenmp
		fi
		append-cxxflags -DOPENMP
	fi
	use python && python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-{makefile,openmp}.patch

	sed -i -e "s@\.\./@${EPREFIX}/usr/bin/@g" tools/*.py \
		|| die "Failed to fix paths in python files"
	if use java; then
		local JAVAC_FLAGS="$(java-pkg_javac-args)"
		sed -i \
			-e "s/JAVAC_FLAGS =/JAVAC_FLAGS=${JAVAC_FLAGS}/g" \
			java/Makefile || die "Failed to fix java makefile"
	fi
}

src_compile() {
	emake
	use java && emake -C java
}

src_install() {
	dobin svm-train svm-predict svm-scale
	dolib.so *.so*
	insinto /usr/include
	doins svm.h
	dohtml FAQ.html
	dodoc README

	if use tools; then
		local t
		for t in tools/*.py; do
			newbin ${t} svm-$(basename ${t} .py)
		done
		newdoc tools/README README.tools
		insinto /usr/share/doc/${PF}
		doins heart_scale
		doins -r svm-toy
	fi

	if use python ; then
		installation() {
			insinto $(python_get_sitedir)
			doins python/*.py
		}
		python_execute_function installation
		newdoc python/README README.python
	fi

	if use java; then
		java-pkg_dojar java/libsvm.jar
		dohtml java/test_applet.html
	fi
}
