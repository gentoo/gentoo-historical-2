# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/protobuf/protobuf-2.3.0.ebuild,v 1.6 2010/05/15 12:15:57 ssuominen Exp $

EAPI="2"

JAVA_PKG_IUSE="source"
PYTHON_DEPEND="python? 2"

inherit autotools eutils distutils python java-pkg-opt-2 elisp-common

DESCRIPTION="Google's Protocol Buffers -- an efficient method of encoding structured data"
HOMEPAGE="http://code.google.com/p/protobuf/"
SRC_URI="http://protobuf.googlecode.com/files/${PF}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x64-macos"
IUSE="emacs examples java python vim-syntax"

DEPEND="${DEPEND} java? ( >=virtual/jdk-1.5 )
	python? ( dev-python/setuptools )
	emacs? ( virtual/emacs )"
RDEPEND="${RDEPEND} java? ( >=virtual/jre-1.5 )
	emacs? ( virtual/emacs )"

PYTHON_MODNAME="google/protobuf"
DISTUTILS_SRC_TEST="setup.py"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch
	eautoreconf

	use python && {
		python_convert_shebangs -r 2 .
		distutils_src_prepare
	}
}

src_compile() {
	emake || die

	if use python; then
		einfo "Compiling Python library ..."
		pushd python
		distutils_src_compile
		popd
	fi

	if use java; then
		einfo "Compiling Java library ..."
		src/protoc --java_out=java/src/main/java --proto_path=src src/google/protobuf/descriptor.proto
		mkdir java/build
		pushd java/src/main/java
		ejavac -d ../../../build $(find . -name '*.java') || die "java compilation failed"
		popd
		jar cf "${PN}.jar" -C java/build . || die "jar failed"
	fi

	if use emacs; then
		elisp-compile "${S}/editors/protobuf-mode.el" || die "elisp-compile failed!"
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc CHANGES.txt CONTRIBUTORS.txt README.txt

	if use python; then
		pushd python
		distutils_src_install
		popd
	fi

	if use java; then
		java-pkg_dojar ${PN}.jar
		use source && java-pkg_dosrc java/src/main/java/*
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins editors/proto.vim
	fi

	if use emacs; then
		elisp-install ${PN} editors/protobuf-mode.el* || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}/70${PN}-gentoo.el"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* || die "doins examples failed"
	fi
}

src_test() {
	emake check

	if use python; then
		 pushd python
		 distutils_src_test
		 popd
	fi
}

pkg_setup() {
	use python && python_set_active_version 2
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use python && distutils_pkg_postrm
}
