# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monodevelop-java/monodevelop-java-2.8.2.ebuild,v 1.1 2011/11/23 19:12:21 pacho Exp $

EAPI="4"

inherit mono multilib versionator

DESCRIPTION="Java Extension for MonoDevelop"
HOMEPAGE="http://www.monodevelop.com/"
SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=dev-lang/mono-2.4
	>=dev-dotnet/gtk-sharp-2.12.9
	>=dev-dotnet/glade-sharp-2.12.9
	>=dev-dotnet/mono-addins-0.3.1
	=dev-util/monodevelop-$(get_version_component_range 1-2)*
	|| ( dev-dotnet/ikvm-bin dev-dotnet/ikvm )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19"

MAKEOPTS="${MAKEOPTS} -j1"

src_configure() {
	MD_JAVA_CONFIG=""
	if use debug; then
		MD_JAVA_CONFIG="--config=DEBUG"
	else
		MD_JAVA_CONFIG="--config=RELEASE"
	fi

	./configure \
		--prefix=/usr		\
		${MD_JAVA_CONFIG}	\
	|| die "configure failed"
}

src_install() {
	default
	mono_multilib_comply
}
