# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/reportlab/reportlab-2.3-r1.ebuild,v 1.7 2009/11/11 00:13:39 ranger Exp $

EAPI="2"
NEED_PYTHON="2.4"
SUPPORT_PYTHON_ABIS="1"

inherit distutils versionator

MY_PN="ReportLab"
MY_PV="$(replace_all_version_separators _)"

DESCRIPTION="Tools for generating printable PDF documents from any data source."
HOMEPAGE="http://www.reportlab.org/"
SRC_URI="http://www.reportlab.org/ftp/${MY_PN}_${MY_PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="doc examples test"

DEPEND="dev-python/imaging
	media-fonts/ttf-bitstream-vera
	media-libs/libart_lgpl
	sys-libs/zlib"
RDEPEND="${DEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_PN}_${MY_PV}"

src_prepare() {
	sed -i \
		-e 's|/usr/lib/X11/fonts/TrueType/|/usr/share/fonts/ttf-bitstream-vera/|' \
		-e 's|/usr/local/Acrobat|/opt/Acrobat|g' \
		-e 's|%(HOME)s/fonts|%(HOME)s/.fonts|g' \
		src/reportlab/rl_config.py || die "sed failed"
	epatch "${FILESDIR}/${PN}-2.2_qa_msg.patch"

	rm -fr src/rl_addons/renderPM/libart_lgpl
	epatch "${FILESDIR}/${P}-external_libart_lgpl.patch"
}

src_compile() {
	distutils_src_compile

	documentation_built="0"
	build_documentation() {
		[[ "${documentation_built}" == "1" ]] && return

		# One of tests already builds documentation.
		if use doc && ! use test; then
			cd docs
			PYTHONPATH="$(ls -d ../build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" genAll.py || die "genAll.py failed"
		fi

		documentation_build="1"
	}
	python_execute_function -q build_documentation
	unset documentation_built
}

src_test() {
	testing() {
		"$(PYTHON)" setup.py tests-preinstall
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use doc; then
		# docs/reference/reportlab-reference.pdf is identical with docs/reportlab-reference.pdf
		rm -f docs/reference/reportlab-reference.pdf

		insinto /usr/share/doc/${PF}
		doins -r docs/*
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r demos
		insinto /usr/share/doc/${PF}/tools/pythonpoint
		doins -r tools/pythonpoint/demos
	fi
}
