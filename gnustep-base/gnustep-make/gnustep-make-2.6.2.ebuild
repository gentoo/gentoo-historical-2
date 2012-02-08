# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-make/gnustep-make-2.6.2.ebuild,v 1.1 2012/02/08 14:37:37 voyageur Exp $

EAPI=4

inherit gnustep-base eutils prefix

DESCRIPTION="GNUstep Makefile Package"

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="libobjc2 native-exceptions"
SLOT="0"
LICENSE="GPL-2"

DEPEND="${GNUSTEP_CORE_DEPEND}
	>=sys-devel/make-3.75
	libobjc2? ( gnustep-base/libobjc2
		>=sys-devel/clang-2.9 )
	!libobjc2? ( !gnustep-base/libobjc2
		>=sys-devel/gcc-3.3[objc] )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ( use libobjc2 && ! has_version gnustep-base/gnustep-make[libobjc2] ) || \
		( ! use libobjc2 && has_version gnustep-base/gnustep-make[libobjc2] ) || \
		( use libobjc2 && has_version <gnustep-base-2.6.2 ) ; then
		ewarn "TOGGLED libobjc2 USE-FLAG WARNING:"
		ewarn "You changed the libojbc2 use-flag"
		ewarn "You must rebuild all gnustep packages installed."
		# Suggest gnustep-updater once it can do the trick
	fi
}

src_prepare() {
	# Multilib-strict
	sed -e "s#/lib#/$(get_libdir)#" -i FilesystemLayouts/fhs-system || die "sed failed"
	epatch "${FILESDIR}"/${PN}-2.0.1-destdir.patch
	cp "${FILESDIR}"/gnustep-4.{csh,sh} "${T}"/
	eprefixify "${T}"/gnustep-4.{csh,sh}
}

src_configure() {
	if use libobjc2; then
		export CC=clang
	fi

	#--enable-objc-nonfragile-abi: only working in clang for now
	#--with-objc-lib-flag: TODO use to force libobjc2 or not
	econf \
		--with-layout=fhs-system \
		--with-config-file="${EPREFIX}"/etc/GNUstep/GNUstep.conf \
		$(use_enable libobjc2 objc-nonfragile-abi) \
		$(use_enable native-exceptions native-objc-exceptions)
}

src_compile() {
	emake
	# Prepare doc here (needed when no gnustep-make is already installed)
	if use doc ; then
		# If a gnustep-1 environment is set
		unset GNUSTEP_MAKEFILES
		pushd Documentation &> /dev/null
		emake all install
		popd &> /dev/null
	fi
}

src_install() {
	# Get GNUSTEP_* variables
	. ./GNUstep.conf

	local make_eval
	use debug || make_eval="${make_eval} debug=no"
	make_eval="${make_eval} verbose=yes"

	emake ${make_eval} DESTDIR="${D}" install

	# Copy the documentation
	if use doc ; then
		dodir ${GNUSTEP_SYSTEM_DOC}
		cp -r Documentation/tmp-installation/System/Library/Documentation/* \
			"${ED}"${GNUSTEP_SYSTEM_DOC=}
	fi

	dodoc FAQ README RELEASENOTES

	exeinto /etc/profile.d
	doexe "${T}"/gnustep-4.sh
	doexe "${T}"/gnustep-4.csh
}

pkg_postinst() {
	# Warn about new layout if old GNUstep directory is still here
	if [ -e /usr/GNUstep/System ]; then
		ewarn "Old layout directory detected (/usr/GNUstep/System)"
		ewarn "Gentoo has switched to FHS layout for GNUstep packages"
		ewarn "You must first update the configuration files from this package,"
		ewarn "then remerge all packages still installed with the old layout"
		ewarn "You can use gnustep-base/gnustep-updater for this task"
	fi
}
