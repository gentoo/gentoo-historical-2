# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/boa-constructor/boa-constructor-0.3.0_alpha.ebuild,v 1.4 2004/11/18 03:06:13 weeve Exp $

BOA=${P/_alpha/}
S=${WORKDIR}/${BOA}
DESCRIPTION="Python GUI RAD development tool."
HOMEPAGE="http://boa-constructor.sourceforge.net/"
SRC_URI="mirror://sourceforge/boa-constructor/${BOA}.src.zip"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ~ppc"
IUSE=""

RDEPEND=">=dev-lang/python-2.0
	=dev-python/wxpython-2.4*
	dev-libs/expat"

DEPEND="${RDEPEND}
	app-arch/unzip"

src_compile() {
	python -c "import compileall; compileall.compile_dir('.', force=1)"
}

src_install () {
	local pv=`python -V 2>&1 | sed -e 's:Python \([0-9].[0-9]\).*:\1:'`
	local boadir="/usr/lib/python${pv}/site-packages/boa"

	local dir
	for dir in `find . -type d`
	do
		insinto "${boadir}/${dir}"
		cd "${dir}"
		local file
		for file in *
		do
			[ -f "${file}" ] && doins "${file}"
		done
		cd "${S}"
	done

	insinto "${boadir}"
	insinto "${boadir}/Plug-ins"
	doins Plug-ins/*

	dobin "${FILESDIR}/boa-constructor"

	dodoc Bugs.txt Changes.txt Credits.txt README.txt
}
