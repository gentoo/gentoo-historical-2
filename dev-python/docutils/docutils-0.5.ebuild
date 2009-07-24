# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/docutils/docutils-0.5.ebuild,v 1.4 2009/07/24 07:35:03 fauli Exp $

EAPI="2"

NEED_PYTHON="2.4"

inherit distutils eutils multilib

DESCRIPTION="Set of python tools for processing plaintext docs into HTML, XML, etc..."
HOMEPAGE="http://docutils.sourceforge.net/"
SRC_URI="mirror://sourceforge/docutils/${P}.tar.gz
	glep? ( mirror://gentoo/glep-0.4-r1.tbz2 )"

LICENSE="public-domain PYTHON BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="glep emacs"

DEPEND="dev-python/setuptools"
# Emacs support is in PDEPEND to avoid a dependency cycle (bug #183242)
PDEPEND="emacs? ( >=app-emacs/rst-0.4 )"

EMP=${PN}-0.3.7

GLEP_SRC=${WORKDIR}/glep-0.4-r1

src_prepare() {
	epatch "${FILESDIR}/${P}-test_node_class_names-python-2.6.patch"

	# simplified algorithm to select installing optparse and textwrap
	epatch "${FILESDIR}"/${EMP}-extramodules.patch

	sed -i \
		-e 's/from distutils.core/from setuptools/' \
		setup.py || die "sed failed"
}

src_compile() {
	distutils_src_compile

	# Generate html docs from reStructured text sources.

	# make roman.py available for the doc building process
	ln -s extras/roman.py

	pushd tools

	# Place html4css1.css in base directory. This makes sure the
	# generated reference to it is correct.
	cp ../docutils/writers/html4css1/html4css1.css ..

	PYTHONPATH=.. ${python} ./buildhtml.py --stylesheet-path=../html4css1.css --traceback .. \
		|| die "buildhtml"

	popd

	# clean up after the doc building
	rm roman.py html4css1.css
}

install_txt_doc() {
	local doc=${1}
	local dir="txt/$(dirname ${doc})"
	docinto ${dir}
	dodoc ${doc}
}

src_test() {
	cd "${S}"/test
	for abi in ${ABIS_PYTHON}; do
		echo -e "\e[1;34mTesting of ${CATEGORY}/${PF} for Python \e[31m${abi}\e[34m...\e[0m"
		PYTHON="$(get_PYTHON ${abi})" PYTHONPATH="${S}" ./alltests.py || die "alltests.py failed"
	done
}

src_install() {
	DOCS="*.txt"
	distutils_src_install
	# Tools
	cd "${S}"/tools
	for tool in *.py
	do
		dobin ${tool}
	done
	# Docs
	cd "${S}"
	dohtml -r docs tools
	# manually install the stylesheet file
	insinto /usr/share/doc/${PF}/html
	doins docutils/writers/html4css1/html4css1.css
	for doc in $(find docs tools -name '*.txt')
	do
		install_txt_doc $doc
	done

	# installing Gentoo GLEP tools. Uses versioned GLEP distribution
	if use glep
	then
		distutils_python_version
		dobin ${GLEP_SRC}/glep.py || die "newbin failed"
		insinto /usr/$(get_libdir)/python${PYVER}/site-packages/docutils/readers
		newins ${GLEP_SRC}/glepread.py glep.py || die "newins reader failed"
		insinto /usr/$(get_libdir)/python${PYVER}/site-packages/docutils/transforms
		newins ${GLEP_SRC}/glepstrans.py gleps.py || die "newins transform failed"
		insinto /usr/$(get_libdir)/python${PYVER}/site-packages/docutils/writers
		doins -r ${GLEP_SRC}/glep_html || die "doins writer failed"
	fi
}
