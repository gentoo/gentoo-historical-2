# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/chardet/chardet-1.0.1.ebuild,v 1.7 2009/11/05 22:26:48 volkmar Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"

inherit distutils

DESCRIPTION="Character encoding auto-detection in Python."
HOMEPAGE="http://chardet.feedparser.org/"
SRC_URI="http://chardet.feedparser.org/download/python2-${P}.tgz
	http://chardet.feedparser.org/download/python3-${P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	default
	cp -pr "python3-${P}" "${P}"

	unpacking() {
		cp -pr "python${PYTHON_ABI:0:1}-${P}" "${S}-${PYTHON_ABI}"
	}
	python_execute_function -q unpacking
}

src_install() {
	distutils_src_install
	dohtml -r "${S}/docs/"*
}
