from myrenderer import MyRenderer
import os
import hydra
import json
import bpy

import sys

sys.stdout = open("stdout.txt", "w", buffering=1)


def render_results(cfg, renderer: MyRenderer):
    save_dir = cfg.renderer.output_path
    print(save_dir)
    os.fsync(sys.stdout)
    sampled_files = renderer.sample_data_files()

    sampled_files = ["1"]

    for file in sampled_files:
        print(file)
        os.fsync(sys.stdout)
        transformation, gt_transformation, acc, init_pose = renderer.load_transformation_data(file)
        
        parts = renderer.load_mesh_parts(file, gt_transformation, init_pose)
        save_path = f"./BlenderToolBox_render/{save_dir}/{file}"
        os.makedirs(save_path, exist_ok=True)
        print("making results directory")
        os.fsync(sys.stdout)

        renderer.save_img(parts, gt_transformation, gt_transformation, init_pose, os.path.join(save_path, "gt.png"))
        print("saved gt image")
        os.fsync(sys.stdout)
        frame = 0

        # bpy.ops.wm.save_mainfile(filepath=save_path + "test" + '.blend')

        for i in range(transformation.shape[0]):
            renderer.render_parts(
                parts, 
                gt_transformation, 
                transformation[i], 
                init_pose, 
                frame,
            )
            print(f"frame {frame}")
            os.fsync(sys.stdout)
            frame += 1

        print("making img directory")
        os.fsync(sys.stdout)
        imgs_path = os.path.join(save_path, "imgs")
        os.makedirs(imgs_path, exist_ok=True)
        renderer.save_video(imgs_path=imgs_path, video_path=os.path.join(save_path, "video.mp4"), frame=frame)
        renderer.clean()
        

@hydra.main(config_path="../config", config_name="auto_aggl")
def main(cfg):
    renderer = MyRenderer(cfg)
    print("created renderer")
    os.fsync(sys.stdout)
    render_results(cfg, renderer)



if __name__ == "__main__":
    main()