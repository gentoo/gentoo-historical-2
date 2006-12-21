# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-driver/alsa-driver-9999.ebuild,v 1.2 2006/12/21 15:57:53 flameeyes Exp $

inherit linux-mod flag-o-matic eutils multilib autotools mercurial

DESCRIPTION="Advanced Linux Sound Architecture kernel modules"
HOMEPAGE="http://www.alsa-project.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

KEYWORDS="-*"
IUSE="oss doc debug"

RDEPEND="virtual/modutils
	 ~media-sound/alsa-headers-${PV}
	 !media-sound/snd-aoa"
DEPEND="${RDEPEND}
	virtual/linux-sources
	sys-apps/debianutils"

PROVIDE="virtual/alsa"

S="${WORKDIR}/alsa-driver"

pkg_setup() {
	# By default, drivers for all supported cards will be compiled.
	# If you want to only compile for specific card(s), set ALSA_CARDS
	# environment to a space-separated list of drivers that you want to build.
	# For example:
	#
	#	env ALSA_CARDS='emu10k1 intel8x0 ens1370' emerge alsa-driver
	#
	ALSA_CARDS=${ALSA_CARDS:-all}

	# Which drivers need PNP
	local PNP_DRIVERS="interwave interwave-stb"

	CONFIG_CHECK="SOUND"
	SND_ERROR="ALSA is already compiled into the kernel."
	SOUND_ERROR="Your kernel doesn't have sound support enabled."
	SOUND_PRIME_ERROR="Your kernel is configured to use the deprecated OSS drivers.	 Please disable them and re-emerge alsa-driver."
	PNP_ERROR="Some of the drivers you selected require PNP in your kernel (${PNP_DRIVERS}).  Either enable PNP in your kernel or trim which drivers get compiled using ALSA_CARDS in /etc/make.conf."

	if [[ "${ALSA_CARDS}" == "all" ]]; then

		# Ignore PNP checks for ppc architecture, as PNP can't be enabled there.
		if [[ ${ARCH} != "ppc" ]]; then
			CONFIG_CHECK="${CONFIG_CHECK} PNP"
		fi
	else
		for pnpdriver in ${PNP_DRIVERS}; do
			hasq ${pnpdriver} ${ALSA_CARDS} && CONFIG_CHECK="${CONFIG_CHECK} PNP"
		done
	fi

	linux-mod_pkg_setup

	if [[ ${PROFILE_ARCH} == "sparc64" ]] ; then
		export CBUILD=${CBUILD-${CHOST}}
		export CHOST="sparc64-unknown-linux-gnu"
	fi
}

src_unpack() {
	mercurial_fetch http://hg.alsa-project.org/alsa-driver
	mercurial_fetch http://hg.alsa-project.org/alsa-kernel alsa-driver/alsa-kernel

	convert_to_m "${S}/Makefile"
	sed -i -e 's:\(.*depmod\):#\1:' "${S}/Makefile"

	cd "${S}"
	emake -j1 ALSAKERNELDIR="${S}/alsa-kernel" all-deps
	eaclocal
	eautoconf
}

src_compile() {
	local myABI=${ABI:-${DEFAULT_ABI}}

	# Should fix bug #46901
	is-flag "-malign-double" && filter-flags "-fomit-frame-pointer"
	append-flags "-I${KV_DIR}/arch/$(tc-arch-kernel)/include"

	ALSAKERNELDIR="${S}/alsa-kernel" \
	econf $(use_with oss) \
		$(use_with debug debug full) \
		--with-kernel="${KV_DIR}" \
		--with-build="${KV_OUT_DIR}" \
		--with-isapnp=yes \
		--with-sequencer=yes \
		--with-cards="${ALSA_CARDS}" || die "econf failed"

	# linux-mod_src_compile doesn't work well with alsa

	ARCH=$(tc-arch-kernel)
	ABI=${KERNEL_ABI}
	emake LDFLAGS="$(raw-ldflags)" HOSTCC=$(tc-getBUILD_CC) CC=$(tc-getCC) || die "Make Failed"
	ARCH=$(tc-arch)
	ABI=${myABI}

	if use doc;
	then
		ebegin "Building Documentation"
		cd ${S}/scripts
		emake || die Failed making docs in ${S}/scripts

		cd ${S}/doc/DocBook
		emake || die Failed making docs in ${S}/doc/DocBook
		eend $?
	fi
}


src_install() {
	emake DESTDIR=${D} install-modules || die "make install failed"

	dodoc CARDS-STATUS FAQ README WARNING TODO

	if use doc; then
		docinto doc
		dodoc doc/*
		rm ${D}/usr/share/doc/${PF}/doc/Makefile.gz

		docinto DocBook
		dodoc doc/DocBook/*
		rm ${D}/usr/share/doc/${PF}/DocBook/Makefile.gz

		docinto Documentation
		dodoc sound/Documentation/*
	fi

	if kernel_is 2 6; then
		# mv the drivers somewhere they won't be killed by the kernel's make modules_install
		mv ${D}/lib/modules/${KV_FULL}/kernel/sound ${D}/lib/modules/${KV_FULL}/${PN}
		rmdir ${D}/lib/modules/${KV_FULL}/kernel &> /dev/null
	fi
}

pkg_postinst() {
	einfo
	einfo "The alsasound initscript and modules.d/alsa have now moved to alsa-utils"
	einfo
	einfo "Also, remember that all mixer channels will be MUTED by default."
	einfo "Use the 'alsamixer' program to unmute them."
	einfo
	einfo "Version 1.0.3 and above should work with version 2.6 kernels."
	einfo "If you experience problems, please report bugs to http://bugs.gentoo.org."
	einfo

	linux-mod_pkg_postinst

	einfo "Check out the ALSA installation guide availible at the following URL:"
	einfo "http://www.gentoo.org/doc/en/alsa-guide.xml"

	if kernel_is 2 6 && [ -e ${ROOT}/lib/modules/${KV_FULL}/kernel/sound ]; then
		# Cleanup if they had older alsa installed
		for file in $(find ${ROOT}/lib/modules/${KV_FULL}/${PN} -type f); do
			rm -f ${file//${KV_FULL}\/${PN}/${KV_FULL}\/kernel\/sound}
		done

		for dir in $(find ${ROOT}/lib/modules/${KV_FULL}/kernel/sound -type d | tac); do
			rmdir ${dir} &> /dev/null
		done
	fi
}
