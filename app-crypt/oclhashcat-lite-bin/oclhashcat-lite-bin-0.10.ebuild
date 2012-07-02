# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/oclhashcat-lite-bin/oclhashcat-lite-bin-0.10.ebuild,v 1.1 2012/07/02 01:25:52 zerochaos Exp $

EAPI=4

inherit eutils pax-utils

DESCRIPTION="An opencl hash cracker"
HOMEPAGE="http://hashcat.net/oclhashcat-lite/"
MY_P="oclHashcat-lite-${PV}"
SRC_URI="http://hashcat.net/files/${MY_P}.7z"

#license applies to this version per http://hashcat.net/forum/thread-1348.html
LICENSE="hashcat"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

IUSE_VIDEO_CARDS="video_cards_fglrx
	video_cards_nvidia"

IUSE="${IUSE_VIDEO_CARDS}"

RDEPEND="sys-libs/zlib
	video_cards_nvidia? ( >=x11-drivers/nvidia-drivers-290.40 )
	video_cards_fglrx?  ( >=x11-drivers/ati-drivers-12.4 )"
DEPEND="${RDEPEND}
	app-arch/p7zip"

S="${WORKDIR}/${MY_P}"

RESTRICT="strip"
QA_PREBUILT="*Hashcat-lite*.bin"

src_install() {
	dodoc docs/*
	rm -rf *.exe docs
	if use x86; then
		rm oclHashcat-lite64.bin
		rm cudaHashcat-lite64.bin
	fi
	if use amd64; then
		rm oclHashcat-lite32.bin
		rm cudaHashcat-lite32.bin
	fi
	if ! use video_cards_fglrx; then
		rm -rf kernels/4098
		rm -f oclHashcat-lite*.bin
	fi
	if ! use video_cards_nvidia; then
		rm -rf kernels/4318
		rm -f cudaHashcat-lite*.bin
	fi

	#I assume this is needed but I didn't check
	pax-mark m *Hashcat-lite*.bin

	insinto /opt/${PN}
	doins -r "${S}"/*

	dodir /usr/bin
	echo '#! /bin/sh' > "${ED}"/usr/bin/oclhashcat-lite
	echo 'echo "oclHashcat-lite and all related files have been installed in /opt/oclhashcat-lite-bin"' >> "${ED}"/usr/bin/oclhashcat-lite
	echo 'echo "Please run one of the following binaries to use gpu accelerated hashcat:"' >> "${ED}"/usr/bin/oclhashcat-lite
	if [ -f "${ED}"/opt/${PN}/oclHashcat-lite64.bin ]
	then
		echo 'echo "64 bit ATI accelerated \"oclHashcat-lite64.bin\""' >> "${ED}"/usr/bin/oclhashcat-lite
		fperms +x /opt/${PN}/oclHashcat-lite64.bin
		echo '#! /bin/sh' > "${ED}"/usr/bin/oclHashcat-lite64.bin
		echo 'cd /opt/oclhashcat-lite-bin' >> "${ED}"/usr/bin/oclHashcat-lite64.bin
		echo 'echo "Warning: oclHashcat-lite64.bin is running from $(pwd) so be careful of relative paths."' >> "${ED}"/usr/bin/oclHashcat-lite64.bin
		echo './oclHashcat-lite64.bin $@' >> "${ED}"/usr/bin/oclHashcat-lite64.bin
		fperms +x /usr/bin/oclHashcat-lite64.bin

	fi
	if [ -f "${ED}"/opt/${PN}/oclHashcat-lite32.bin ]
	then
		echo 'echo "32 bit ATI accelerated \"oclHashcat-lite32.bin\""' >> "${ED}"/usr/bin/oclhashcat-lite
		fperms +x /opt/${PN}/oclHashcat-lite32.bin
		echo '#! /bin/sh' > "${ED}"/usr/bin/oclHashcat-lite32.bin
		echo 'cd /opt/oclhashcat-lite-bin' >> "${ED}"/usr/bin/oclHashcat-lite32.bin
		echo 'echo "Warning: oclHashcat-lite32.bin is running from $(pwd) so be careful of relative paths."' >> "${ED}"/usr/bin/oclHashcat-lite32.bin
		echo './oclHashcat-lite32.bin $@' >> "${ED}"/usr/bin/oclHashcat-lite32.bin
		fperms +x /usr/bin/oclHashcat-lite32.bin
	fi
	if [ -f "${ED}"/opt/${PN}/cudaHashcat-lite64.bin ]
	then
		echo 'echo "64 bit NVIDIA accelerated \"cudaHashcat-lite64.bin\""' >> "${ED}"/usr/bin/oclhashcat-lite
		fperms +x /opt/${PN}/cudaHashcat-lite64.bin
		echo '#! /bin/sh' > "${ED}"/usr/bin/cudaHashcat-lite64.bin
		echo 'cd /opt/oclhashcat-lite-bin' >> "${ED}"/usr/bin/cudaHashcat-lite64.bin
		echo 'echo "Warning: cudaHashcat-lite64.bin is running from $(pwd) so be careful of relative paths."' >> "${ED}"/usr/bin/cudaHashcat-lite64.bin
		echo './cudaHashcat-lite64.bin $@' >> "${ED}"/usr/bin/cudaHashcat-lite64.bin
		fperms +x /usr/bin/cudaHashcat-lite64.bin

	fi
	if [ -f "${ED}"/opt/${PN}/cudaHashcat-lite32.bin ]
	then
		echo 'echo 32 bit NVIDIA accelerated \"cudaHashcat-lite32.bin\""' >> "${ED}"/usr/bin/oclhashcat-lite
		fperms +x /opt/${PN}/cudaHashcat-lite32.bin
		echo '#! /bin/sh' > "${ED}"/usr/bin/cudaHashcat-lite32.bin
		echo 'cd /opt/oclhashcat-lite-bin' >> "${ED}"/usr/bin/cudaHashcat-lite32.bin
		echo 'echo "Warning: cudaHashcat-lite32.bin is running from $(pwd) so be careful of relative paths."' >> "${ED}"/usr/bin/cudaHashcat-lite32.bin
		echo './cudaHashcat-lite32.bin $@' >> "${ED}"/usr/bin/cudaHashcat-lite32.bin
		fperms +x /usr/bin/oclHashcat-lite32.bin
	fi
	fperms +x /usr/bin/oclhashcat-lite
	fowners root:video /opt/${PN}
	einfo "oclhashcat-lite can be run as user if you are in the video group"
}
