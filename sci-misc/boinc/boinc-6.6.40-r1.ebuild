# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/boinc/boinc-6.6.40-r1.ebuild,v 1.2 2009/09/29 17:45:00 scarabeus Exp $

EAPI="2"

inherit flag-o-matic depend.apache eutils wxwidgets autotools

DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="http://boinc.ssl.berkeley.edu/"
SRC_URI="http://dev.gentooexperimental.org/~scarabeus/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="X +client cuda server"

RDEPEND="
	!sci-misc/boinc-bin
	!app-admin/quickswitch
	>=app-misc/ca-certificates-20080809
	dev-libs/openssl
	net-misc/curl
	sys-apps/util-linux
	sys-libs/zlib
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-2.1
		>=x11-drivers/nvidia-drivers-180.22
	)
	server? (
		>=virtual/mysql-5.0
		dev-python/mysql-python
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	server? ( virtual/imap-c-client )
	X? (
		media-libs/freeglut
		media-libs/jpeg
		x11-libs/wxGTK:2.8[X,opengl]
	)
"

src_prepare() {
	# use system ssl certificates
	mkdir "${S}"/curl
	cp /etc/ssl/certs/ca-certificates.crt "${S}"/curl/ca-bundle.crt

	# prevent bad changes in compile flags, bug 286701
	sed -i -e "s:BOINC_SET_COMPILE_FLAGS::" configure.ac || die "sed failed"

	epatch \
		"${FILESDIR}"/6.4.5-glibc210.patch \
		"${FILESDIR}"/${PV}-*

	eautoreconf
}

src_configure() {
	local wxconf=""
	local conf=""

	# define preferable CFLAGS (recommended by upstream)
	append-flags -O3 -funroll-loops -fforce-addr -ffast-math

	# look for wxGTK
	if use X; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode
		wxconf+=" --with-wx-config=${WX_CONFIG}"
	else
		wxconf+=" --without-wxdir"
	fi

	# Bug #248769: don't use strlcat and friends from kerberos or similar
	#local func
	#for func in strlcat strlcpy; do
	#	eval "export ac_cv_func_${func}=no"
	#	append-cppflags -D${func}=boinc_${func}
	#done
	use server || conf+=" --disable-server"
	use X || conf+=" --disable-manager"
	use client || conf+=" --disable-client"

	# configure
	econf \
		--disable-dependency-tracking \
		--enable-unicode \
		--with-ssl \
		--enable-optimize \
		$(use_with X x) \
		${wxconf} \
		${conf}
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodir /var/lib/${PN}/
	keepdir /var/lib/${PN}/

	if use X; then
		newicon "${S}"/packages/generic/sea/${PN}mgr.48x48.png ${PN}.png || die
		make_desktop_entry boincmgr "${PN}" "${PN}" "Math;Science" /var/lib/${PN}
	fi

	# cleanup cruft
	rm -rf "${D}"/etc/

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}
}

pkg_setup() {
	enewgroup ${PN}
	# note this works only for first install so we have to
	# elog user about the need of being in video group
	if use cuda; then
		enewuser ${PN} -1 -1 /var/lib/${PN} "${PN},video"
	else
		enewuser ${PN} -1 -1 /var/lib/${PN} "${PN}"
	fi
}

pkg_postinst() {
	echo
	elog "You are using the source compiled version of ${PN}."
	use X && elog "The graphical manager can be found at /usr/bin/${PN}mgr"
	elog
	elog "You need to attach to a project to do anything useful with ${PN}."
	elog "You can do this by running /etc/init.d/${PN} attach"
	elog "The howto for configuration is located at:"
	elog "http://boinc.berkeley.edu/wiki/Anonymous_platform"
	elog
	# Add warning about the new password for the client, bug 121896.
	if use X; then
		elog "If you need to use the graphical manager the password is in:"
		elog "/var/lib/${PN}/gui_rpc_auth.cfg"
		elog "Where /var/lib/ is default RUNTIMEDIR, that can be changed in:"
		elog "/etc/conf.d/${PN}"
		elog "You should change this password to something more memorable (can be even blank)."
		elog "Remember to launch init script before using manager. Or changing the password."
		elog
	fi
	if use cuda; then
		elog "To be able to use CUDA you should add boinc user to video group."
		elog "To do so run as root:"
		elog "gpasswd -a boinc video"
	fi
}
