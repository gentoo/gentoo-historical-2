# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/ndoc/ndoc-1.3.1-r2.ebuild,v 1.2 2006/03/19 22:12:35 halcy0n Exp $

inherit mono

DESCRIPTION=".NET Documentation Tool"
HOMEPAGE="http://ndoc.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${PN}-devel-v${PV}.zip"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"
IUSE="debug doc"
DEPEND=">=dev-lang/mono-1.0
	>=dev-dotnet/nant-0.85_rc2
	app-arch/unzip"
RDEPEND=">=dev-lang/mono-1.0"

S=${WORKDIR}

src_compile() {
	# Workaround some unused private warnings which the buildfiles are treating as errors
	find ${S} -name '*.build' -exec sed -e 's@warnaserror="true"@@g' -i {} \;

	nant -t:mono-1.0 || die
}

DLL_FILES="NDoc.Core.dll NDoc.Documenter.JavaDoc.dll NDoc.Documenter.Latex.dll NDoc.Documenter.LinearHtml.dll NDoc.Documenter.Msdn.dll NDoc.Documenter.Msdn2.dll NDoc.Documenter.Xml.dll NDoc.ExtendedUI.dll NDoc.VisualStudio.dll"

src_install() {
	cd ${S}/bin/mono/1.0

	# This installs all of the dll files with the exe file
	# directory.
	insinto /usr/share/ndoc
	for dll in $DLL_FILES; do
				doins $dll || die "Failed to install $dll."
	done

	DEBUG_VAR=""

	use debug && DEBUG_VAR="--debug"

	cat > ndoc <<- EOF
		#!/bin/bash

		mono $DEBUG_VAR /usr/share/ndoc/NDocConsole.exe "\$@"
	EOF

	insinto /usr/share/ndoc/
	doins NDocConsole.exe
	dobin ndoc

	use doc && dohtml -a gif,html,css,js -r ${S}/doc/sdk/
}
