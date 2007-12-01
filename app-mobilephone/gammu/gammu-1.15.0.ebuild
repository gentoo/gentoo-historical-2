# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/gammu/gammu-1.15.0.ebuild,v 1.1 2007/12/01 09:36:17 mrness Exp $

inherit multilib

DESCRIPTION="a fork of the gnokii project, a tool to handle your cellular phone"
HOMEPAGE="http://www.gammu.org"
SRC_URI="ftp://dl.cihar.com/gammu/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug bluetooth irda mysql postgres nls"

RDEPEND="bluetooth? ( net-wireless/bluez-libs )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	dev-util/dialog"
DEPEND="${RDEPEND}
	irda? ( virtual/os-headers )
	nls? ( sys-devel/gettext )
	dev-util/cmake"

# Supported languages and translated documentation
# Be sure all languages are prefixed with a single space!
MY_AVAILABLE_LINGUAS=" cs de es it pl ru"
IUSE="${IUSE} ${MY_AVAILABLE_LINGUAS// / linguas_}"

src_unpack() {
	unpack ${A}

	# sys-devel/gettext is needed for creating .mo files
	cd "${S}/locale"
	local lang
	for lang in ${MY_AVAILABLE_LINGUAS} ; do
		if ! use linguas_${lang} ; then
			sed -i -e "/^[[:space:]]*${lang}[[:space:]]*$/d" CMakeLists.txt
		fi
	done
}

my_use_with() {
	local WITH_PREFIX
	if [ -n "${2}" ]; then
		WITH_PREFIX="-DWITH_${2}"
	else
		WITH_PREFIX="-DWITH_${1}"
	fi
	if use $1 ; then
		echo ${WITH_PREFIX}=ON
	else
		echo ${WITH_PREFIX}=OFF
	fi
}

src_compile() {
	local myconf="$(my_use_with bluetooth Bluez) \
		$(my_use_with irda IrDA) \
		$(my_use_with mysql MySQL) \
		$(my_use_with postgres Postgres)"
	use debug && myconf="${myconf} -DCMAKE_BUILD_TYPE=Debug"

	mkdir "${S}/build" && \
		cd "${S}/build" && \
		cmake .. \
			-DCMAKE_INSTALL_PREFIX=/usr \
			-DINSTALL_LIB_DIR=/usr/$(get_libdir) \
			-DINSTALL_DOC_DIR="/usr/share/doc/${P}" \
			-DENABLE_SHARED=ON \
			-DHAVE_SIN=NO \
			${myconf} || die "cmake failed"
	emake || die "make failed"
}

src_install () {
	cd "${S}/build"
	make DESTDIR="${D}" install || die "install failed"
}
