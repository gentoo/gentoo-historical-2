# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/virtualbox-ose/virtualbox-ose-2.1.4-r1.ebuild,v 1.2 2009/03/11 09:24:46 jokey Exp $

EAPI=2

inherit eutils fdo-mime flag-o-matic linux-info pax-utils qt4 toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	# XXX: should finish merging the -9999 ebuild into this one ...
	ESVN_REPO_URI="http://www.virtualbox.org/svn/vbox/trunk"
	inherit linux-mod subversion
else
	MY_P=VirtualBox-${PV}-OSE
	SRC_URI="http://download.virtualbox.org/virtualbox/${PV}/${MY_P/-O/-3-O}.tar.bz2"
	S=${WORKDIR}/${MY_P/-OSE/_OSE}
fi

DESCRIPTION="Software family of powerful x86 virtualization"
HOMEPAGE="http://www.virtualbox.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+additions alsa +hal headless pulseaudio python +qt4 sdk vboxwebsrv"

RDEPEND="!app-emulation/virtualbox-bin
	~app-emulation/virtualbox-modules-${PV}
	dev-libs/libIDL
	>=dev-libs/libxslt-1.1.19
	!headless? (
		qt4? ( || ( ( x11-libs/qt-gui x11-libs/qt-core ) =x11-libs/qt-4.3*:4 ) )
		x11-libs/libXcursor
		media-libs/libsdl[X]
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}
	>=dev-util/kbuild-0.1.5
	>=dev-lang/yasm-0.6.2
	sys-devel/bin86
	sys-devel/dev86
	sys-power/iasl
	media-libs/libpng
	sys-libs/libcap
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	hal? ( sys-apps/hal )
	pulseaudio? ( media-sound/pulseaudio )
	python? ( >=dev-lang/python-2.3 )
	vboxwebsrv? ( <=net-libs/gsoap-2.7.9f )"
RDEPEND="${RDEPEND}
	additions? ( ~app-emulation/virtualbox-ose-additions-${PV} )
	sys-apps/usermode-utilities
	net-misc/bridge-utils"

pkg_setup() {
	if ! use headless && ! use qt4 ; then
		einfo "No USE=\"qt4\" selected, this build will not include"
		einfo "any Qt frontend."
	elif use headless && use qt4 ; then
		einfo "You selected USE=\"headless qt4\", defaulting to"
		einfo "USE=\"headless\", this build will not include any X11/Qt frontend."
	fi
}

src_prepare() {
	# Remove shipped binaries (kBuild,yasm), see bug #232775
	rm -rf kBuild/bin tools

	# Disable things unused or split into separate ebuilds
	sed -e "s/MY_LIBDIR/$(get_libdir)/" \
		"${FILESDIR}"/${PN}-2-localconfig > LocalConfig.kmk || die

	# Fix an upstream typo in Config.kmk, bug #251335
	sed -i -e "2511d" Config.kmk || die "Config.kmk sed failed"
}

src_configure() {
	local myconf
	use alsa       || myconf="${myconf} --disable-alsa"
	use pulseaudio || myconf="${myconf} --disable-pulse"
	use python     || myconf="${myconf} --disable-python"
	use hal        || myconf="${myconf} --disable-dbus"
	use vboxwebsrv && myconf="${myconf} --enable-webservice"
	if ! use headless ; then
		use qt4 || myconf="${myconf} --disable-qt4"
	else
		myconf="${myconf} --build-headless"
	fi
	# not an autoconf script
	./configure \
		--with-gcc="$(tc-getCC)" \
		--with-g++="$(tc-getCXX)" \
		--disable-kmods \
		--disable-qt3 \
		${myconf} \
		|| die "configure failed"
}

src_compile() {
	source ./env.sh

	# Force kBuild to respect C[XX]FLAGS and MAKEOPTS (bug #178529)
	# and strip all flags
	strip-flags

	MAKE="kmk" emake \
		TOOL_GCC3_CC="$(tc-getCC)" TOOL_GCC3_CXX="$(tc-getCXX)" \
		TOOL_GCC3_AS="$(tc-getCC)" TOOL_GCC3_AR="$(tc-getAR)" \
		TOOL_GCC3_LD="$(tc-getCXX)" TOOL_GCC3_LD_SYSMOD="$(tc-getLD)" \
		TOOL_GCC3_CFLAGS="${CFLAGS}" TOOL_GCC3_CXXFLAGS="${CXXFLAGS}" \
		TOOL_YASM_AS=yasm KBUILD_PATH="${S}/kBuild" \
		all || die "kmk failed"
}

src_install() {
	cd "${S}"/out/linux.*/release/bin || die

	# Create configuration files
	insinto /etc/vbox
	newins "${FILESDIR}/${PN}-2-config" vbox.cfg

	# Set the right libdir
	sed -i \
		-e "s/MY_LIBDIR/$(get_libdir)/" \
		"${D}"/etc/vbox/vbox.cfg || die "vbox.cfg sed failed"

	# Symlink binaries to the shipped wrapper
	exeinto /usr/$(get_libdir)/${PN}
	newexe "${FILESDIR}/${PN}-2-wrapper" "VBox" || die
	fowners root:vboxusers /usr/$(get_libdir)/${PN}/VBox
	fperms 0750 /usr/$(get_libdir)/${PN}/VBox

	dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VBoxManage
	dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VBoxVRDP
	dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VBoxHeadless
	dosym /usr/$(get_libdir)/${PN}/VBoxTunctl /usr/bin/VBoxTunctl

	# Install binaries and libraries
	insinto /usr/$(get_libdir)/${PN}
	doins -r components || die

	if use sdk ; then
		doins -r sdk || die
	fi

	if use vboxwebsrv ; then
		doins vboxwebsrv || die
		fowners root:vboxusers /usr/$(get_libdir)/${PN}/vboxwebsrv
		fperms 0750 /usr/$(get_libdir)/${PN}/vboxwebsrv
		dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/vboxwebsrv
		newinitd "${FILESDIR}"/vboxwebsrv-initd vboxwebsrv
		newconfd "${FILESDIR}"/vboxwebsrv-confd vboxwebsrv
	fi

	for each in VBox{Manage,SVC,XPCOMIPCD,Tunctl} *so *r0 *gc ; do
		doins $each || die
		fowners root:vboxusers /usr/$(get_libdir)/${PN}/${each}
		fperms 0750 /usr/$(get_libdir)/${PN}/${each}
	done

	if ! use headless ; then
		for each in VBox{SDL,Headless} ; do
			doins $each || die
			fowners root:vboxusers /usr/$(get_libdir)/${PN}/${each}
			fperms 4750 /usr/$(get_libdir)/${PN}/${each}
			pax-mark -m "${D}"/usr/$(get_libdir)/${PN}/${each}
		done

		dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VBoxSDL

		if use qt4 ; then
			doins VirtualBox || die
			fowners root:vboxusers /usr/$(get_libdir)/${PN}/VirtualBox
			fperms 4750 /usr/$(get_libdir)/${PN}/VirtualBox
			pax-mark -m "${D}"/usr/$(get_libdir)/${PN}/VirtualBox

			dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VirtualBox
		fi

		newicon	"${S}"/src/VBox/Frontends/VirtualBox/images/OSE/VirtualBox_32px.png ${PN}.png
		domenu "${FILESDIR}"/${PN}.desktop
	else
		doins VBoxHeadless || die
		fowners root:vboxusers /usr/$(get_libdir)/${PN}/VBoxHeadless
		fperms 4750 /usr/$(get_libdir)/${PN}/VBoxHeadless
		pax-mark -m "${D}"/usr/$(get_libdir)/${PN}/VBoxHeadless
	fi

	insinto /usr/share/${PN}
	doins -r nls
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	if ! use headless ; then
		elog "To launch VirtualBox just type: \"VirtualBox\""
	fi
	elog "You must be in the vboxusers group to use VirtualBox."
	elog ""
	elog "The lastest user manual is available for download at:"
	elog "http://download.virtualbox.org/virtualbox/${PV}/UserManual.pdf"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
