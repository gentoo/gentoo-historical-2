# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/sdrsharp/sdrsharp-9999.ebuild,v 1.2 2012/09/10 06:11:56 zerochaos Exp $

EAPI=4

inherit subversion

DESCRIPTION="simple, intuitive, small and fast DSP application for SDR"
HOMEPAGE="http://sdrsharp.com/"
ESVN_REPO_URI="https://subversion.assembla.com/svn/sdrsharp/trunk"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/mono
	media-libs/portaudio
	net-wireless/rtl-sdr"
RDEPEND="${DEPEND}"

src_compile() {
	xbuild /t:Rebuild /p:Configuration=Release SDRSharp.sln
}

src_install() {
	cd "${S}"/Release

	#remove windows only stuff
	sed -i -e "/FUNcube/d" SDRSharp.exe.config
	sed -i -e "/SoftRock/d" SDRSharp.exe.config
	rm -f SDRSharp.FUNcube.dll SDRSharp.SoftRock.dll

	#install
	insinto /usr/$(get_libdir)/${PN}
	doins SDRSharp.exe* *.dll
	dobin "${FILESDIR}"/sdrsharp
	sed -i "s#GETLIBDIR#$(get_libdir)#" "${ED}"/usr/bin/sdrsharp
}
