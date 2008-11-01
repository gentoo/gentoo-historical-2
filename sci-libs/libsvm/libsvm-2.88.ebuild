# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libsvm/libsvm-2.88.ebuild,v 1.1 2008/11/01 13:21:58 markusle Exp $

inherit java-pkg-opt-2 python toolchain-funcs multilib

DESCRIPTION="Library for Support Vector Machines"
HOMEPAGE="http://www.csie.ntu.edu.tw/~cjlin/libsvm/"
SRC_URI="http://www.csie.ntu.edu.tw/~cjlin/libsvm/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="java python tools"

DEPEND="java? ( >=virtual/jdk-1.4 )"
RDEPEND="${DEPEND}
	tools? ( sci-visualization/gnuplot )"

src_compile() {
	emake \
		CXXC="$(tc-getCXX)" \
		CFLAGS="${CXXFLAGS}" \
		|| die "emake failed"

	sed -i -e 's@\.\./@/usr/bin/@g' tools/*.py \
		|| die "Failed to fix paths in python files"

	if use python ; then
		pushd python
		python_version || die "python_version failed"
		emake \
			CC="$(tc-getCXX)" \
			CFLAGS="${CXXFLAGS} -I/usr/include/python${PYVER} -I.." \
			all || die "emake for python modules failed"
		popd
	fi

	if use java ; then
		pushd java
		local JAVAC_FLAGS="$(java-pkg_javac-args)"
		sed -i \
			-e "s/JAVAC_FLAGS =/JAVAC_FLAGS=${JAVAC_FLAGS}/g" \
			Makefile || die "Failed to fix java makefile"
		emake || die "emake for java modules failed"
		popd
	fi
}

src_install() {
	dobin svm-train svm-predict svm-scale \
		|| die "Failed to install binaries"
	dohtml FAQ.html
	dodoc README

	if use tools; then
		pushd tools
		insinto /usr/share/${PN}/tools
		doins easy.py grid.py subset.py \
			|| die "Failed to install python tools"
		docinto tools
		dodoc README
		popd
	fi

	if use python ; then
		pushd python
		python_version || die
		insinto /usr/$(get_libdir)/python${PYVER}/site-packages
		doins svmc.so svm.py \
			|| die "Failed to install python scripts"
		docinto python
		dodoc README
		popd
	fi

	if use java; then
		pushd java
		java-pkg_dojar libsvm.jar
		docinto java
		dohtml test_applet.html
		popd
	fi
}
